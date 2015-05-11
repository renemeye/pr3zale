class Order < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :event
  belongs_to :paid_by, class_name: User, foreign_key: :paid_by_user_id
  belongs_to :repaid_by, class_name: User, foreign_key: :repaid_by_user_id
  belongs_to :canceled_by, class_name: User, foreign_key: :canceled_by_user_id

  has_many :sold_products, :dependent => :destroy
  accepts_nested_attributes_for :sold_products
  scope :on_event, ->(event) { where event: event }
  scope :open_orders, -> {with_state(:reserved)}
  default_scope { order('created_at ASC') }

  before_create :generate_transfer_token
  before_create :randomize_id

  def sum
    sold_products.collect{|p|p.price}.sum - sum_repaid()
  end

  def sum_repaid
    sold_products.repaid_products.collect{|p|p.price}.sum
  end

  def to_s
    sold_products.collect{|p|p.name}.uniq.join(", ") + " | #{I18n.t ".models.order.X products overall", count: sold_products.length}"
  end

  #states: :reseverd, :paid, :canceled, :repaid
  state_machine initial: :reserved do
    event :purchase do
      transition :reserved => :paid
    end

    event :cancel do
      transition :reserved => :canceled
    end

    event :repay do
      transition :paid => :repaid
    end

    after_transition any => :repaid do |order, transition|
      order.update repaid_by: transition.args.first[:by], repaid_at: Time.now
      order.sold_products.each do |sold_product|
        sold_product.repay(by: transition.args.first[:by])
      end
    end

    after_transition any => :paid do |order, transition|
      order.update paid_by: transition.args.first[:by], paid_at: Time.now
      OrderMailer.purchase_confirmation(order.user, order).deliver unless order.sum == 0
      order.sold_products.each do |sold_product|
        sold_product.purchase(by: transition.args.first[:by])
      end
    end

    after_transition any => :canceled do |order, transition|
      order.update canceled_by: transition.args.first[:by], canceled_at: Time.now
      order.sold_products.each do |sold_product|
        sold_product.cancel(by: transition.args.first[:by])
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
      distinctive_letters = ['A', 'B', 'C', 'D', 'E', 'F', 'H', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'W', 'X', 'Y', '2', '3', '4', '7', '8', '9']
      random_token = (0...12).map { distinctive_letters[rand(distinctive_letters.length)] }.join
      break random_token unless Order.exists?(transfer_token: random_token)
    end
    self.transfer_token += "-"+Order.generate_check_sum(self.transfer_token)
    self.transfer_token = "#{self.event.transfer_token_prefix.upcase} #{self.transfer_token}" unless self.event.transfer_token_prefix.blank?
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

    possible_col_seperators = [';',',']
    try_seperator_nr = 0

    begin

      SmarterCSV.process(tmpfile.path, col_sep: possible_col_seperators[try_seperator_nr]) do |row|
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
        else
          no_token_entries+=row
        end
      end

    rescue CSV::MalformedCSVError
      try_seperator_nr += 1
      raise CSV::MalformedCSVError, "Can't parse CSV, tried: #{possible_col_seperators.join(" ")}" if try_seperator_nr >= possible_col_seperators.length

      retry
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
