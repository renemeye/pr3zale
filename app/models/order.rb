class Order < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :sold_products, :dependent => :destroy
  accepts_nested_attributes_for :sold_products

  def sum
    sold_products.collect{|a|a.price}.sum
  end
end
