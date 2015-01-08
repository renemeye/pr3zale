class Product < ActiveRecord::Base
  has_paper_trail
  belongs_to :event
  has_many :images, as: :imageable, dependent: :destroy
end
