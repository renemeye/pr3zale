class Event < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  has_many :products
  has_many :orders
end
