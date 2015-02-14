class Event < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  has_many :products
  has_many :orders
  has_many :cooperators
  has_many :sold_products
  has_many :users, :through => :sold_products

  def is_coordiantor? (user)
    self.cooperators.coordinators.collect{|coordinator|coordinator.user}.include? user
  end
end
