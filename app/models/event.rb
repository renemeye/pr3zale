class Event < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  has_many :products
  has_many :orders
  has_many :cooperators
  has_many :sold_products
  has_many :users, :through => :sold_products

  has_attached_file :bill_logo
  validates_attachment_content_type :bill_logo, :content_type => "image/svg+xml"

  def is_coordiantor? (user)
    self.cooperators.coordinators.collect{|coordinator|coordinator.user}.include? user
  end
  def is_cooperator? (user)
    self.cooperators.collect{|cooperator|cooperator.user}.include? user
  end
end
