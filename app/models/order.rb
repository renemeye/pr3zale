class Order < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :sold_products, :dependent => :destroy
  accepts_nested_attributes_for :sold_products
  scope :on_event, ->(event) { where event: event }
  scope :open_orders, -> {with_state(:reserved)}

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
end
