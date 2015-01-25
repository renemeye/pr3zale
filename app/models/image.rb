class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  has_attached_file :image, styles: {thumb: "100x100#"}

  validates_attachment :image,
  :presence => true,
  :content_type => { :content_type => /\Aimage\/.*\Z/ }
end
