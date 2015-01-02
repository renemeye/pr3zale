class Product < ActiveRecord::Base
  belongs_to :event
  has_many :images, as: :imageable, dependent: :destroy
end
