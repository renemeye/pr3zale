class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :orders
  has_many :cooperations, :class_name => "Cooperator"

  def is_coordinator? (event)
    event.cooperators.coordinators.collect{|coordinator|coordinator.user}.include? self
  end
  def is_cooperator? (event)
    event.cooperators.collect{|cooperator|cooperator.user}.include? self
  end
end
