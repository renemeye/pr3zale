class Order < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :sold_products, :dependent => :destroy
  accepts_nested_attributes_for :sold_products
  scope :on_event, ->(event) { where event: event }

  def sum
    sold_products.collect{|p|p.price}.sum
  end

  def to_s
    sold_products.collect{|p|p.name}.uniq.join(", ") + " | #{sold_products.length} product#{"s" unless sold_products.length == 1} overall"
  end
end
