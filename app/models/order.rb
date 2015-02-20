class Order < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :sold_products, :dependent => :destroy
  accepts_nested_attributes_for :sold_products
  scope :on_event, ->(event) { where event: event }
  scope :open_orders, -> {with_state(:reserved)}

  before_create :generate_transfer_token

  def sum
    sold_products.collect{|p|p.price}.sum
  end

  def to_s
    sold_products.collect{|p|p.name}.uniq.join(", ") + " | #{sold_products.length} product#{"s" unless sold_products.length == 1} overall"
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
  def generate_check_sum(input)
    sum = 0
    for i in 0..(input.length-1)
      sum += input[i].to_i(36)*((2**(((input.length-1)-i)%3+1))-1)
      #Debug and description:
      # puts "Value of char is #{input[i]} (#{input[i].to_i(36)}) multiplied by #{(2**(((input.length-1)-i)%3+1))-1} -> #{input[i].to_i(36)*((2**(((input.length-1)-i)%3+1))-1)} -> Sum: (#{sum})"
    end
    (sum % 100).to_s().rjust(2, "0").upcase
  end

  #Checks if it has a valid checksum
  def check_transfer_token(input)
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
    self.transfer_token += "-"+generate_check_sum(self.transfer_token)
  end

end
