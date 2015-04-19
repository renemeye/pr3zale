class Order < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :sold_products, :dependent => :destroy
  accepts_nested_attributes_for :sold_products
  scope :on_event, ->(event) { where event: event }
  scope :open_orders, -> {with_state(:reserved)}
  default_scope { order('created_at ASC') }

  before_create :generate_transfer_token
  before_create :randomize_id

  def sum
    sold_products.collect{|p|p.price}.sum
  end

  def to_s
    sold_products.collect{|p|p.name}.uniq.join(", ") + " | #{I18n.t ".models.order.X products overall", count: sold_products.length}"
  end

  #states: :reseverd, :paid, :canceled
  state_machine initial: :reserved do
    event :purchase do
      transition :reserved => :paid
    end

    event :cancel do
      transition :reserved => :canceled
    end

    after_transition any => :paid do |order, transition|
      OrderMailer.purchase_confirmation(order.user, order).deliver
      order.sold_products.each do |sold_product|
        sold_product.purchase
      end
    end

    after_transition any => :canceled do |order, transition|
      order.sold_products.each do |sold_product|
        sold_product.cancel
      end
    end

  end

  # This is the check_digit algorithm of the german Personalausweisnummer http://de.wikipedia.org/wiki/Ausweisnummer
  # With one difference, we take a two digit check sum here
  # It works with inputs on values 0-9,A-Z an input length divisable by 3
  def self.generate_check_sum(input)
    sum = 0
    for i in 0..(input.length-1)
      sum += input[i].to_i(36)*((2**(((input.length-1)-i)%3+1))-1)
      #Debug and description:
      # puts "Value of char is #{input[i]} (#{input[i].to_i(36)}) multiplied by #{(2**(((input.length-1)-i)%3+1))-1} -> #{input[i].to_i(36)*((2**(((input.length-1)-i)%3+1))-1)} -> Sum: (#{sum})"
    end
    (sum % 100).to_s().rjust(2, "0").upcase
  end

  #Checks if it has a valid checksum
  def self.check_transfer_token(input)
    return false unless input.is_a? String
    parts = /^([0-9A-Z]*)-([0-9][0-9])$/.match(input)
    return false if parts.nil?
    test_string = parts[1]
    check_sum = parts[2]
    return check_sum == generate_check_sum(test_string)
  end

  #Creates a random string of length 12 with characters 0-9,A-Z
  #and adds a "-" and a two digits check sum
  def generate_transfer_token
    self.transfer_token = loop do
      random_token = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0").upcase
      break random_token unless Order.exists?(transfer_token: random_token)
    end
    self.transfer_token += "-"+Order.generate_check_sum(self.transfer_token)
  end

  def self.regex_extracting_transfer_token
    /([0-9A-Z]{12}-[0-9][0-9])/
  end

  #Creates a random ID in order to not know how much stuff is sold
  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while Order.where(id: self.id).exists?
  end

  def unissued_count
    Rails.cache.fetch([self, "unissued_count"]) do
      if self.paid?
        self.sold_products.unissued_orders.length
      else
        0
      end
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["Ticket Nr.", "State", "Verification Token", "Bestell Nr.", "Preis", "Ticketart"]
      all.each do |order|
        if order.paid?
          order.sold_products.each do |sold_product|
            csv << sold_product.attributes.values_at("id", "state", "verification_token", "order_id") + [sold_product.price, sold_product.name]
          end
        end
      end
    end
  end

  def self.import_payments_from_csv(event, csv_file)

    #Forcing CSV to be utf-8
    tmpfile = Tempfile.new(csv_file.original_filename)
    tmpfile.write(File.read(csv_file.path).encode('utf-8', 'binary', invalid: :replace, undef: :replace, replace: ''))
    tmpfile.rewind

    matched_entries = Array.new()
    problem_entries = Array.new()
    no_token_entries = Array.new()

    SmarterCSV.process(tmpfile.path, col_sep: ";") do |row|
      if match = has_transfer_token?(row[0])

        if check_transfer_token(match)

          if order = event.orders.find_by_transfer_token(match)
            row[0][:order] = order
            matched_entries += row
          else
            row[0][:problem] = I18n.t"Can't find transfer token in Database."
            problem_entries += row
          end
        else
          row[0][:problem] = I18n.t"Invalid transfer token"
          problem_entries += row
        end

        # if row[0][:waehrung] == "EUR"
        #
        # end

      else
        no_token_entries+=row
      end
    end
    return {matched_entries: matched_entries, problem_entries: problem_entries, no_token_entries: no_token_entries}
  ensure
    tmpfile.close if tmpfile
    tmpfile.unlink if tmpfile
  end

  def self.has_transfer_token?(hash)
    hash.each do |key, value|
      match = Order.regex_extracting_transfer_token.match(value.to_s.upcase.gsub(/\s+/, ""))
      return match[1] if match
    end
    return false
  end
end
