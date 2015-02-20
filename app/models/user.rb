class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :orders
  has_many :cooperations, :class_name => "Cooperator"
  before_create :randomize_id

  def is_coordinator? (event)
    event.cooperators.coordinators.collect{|coordinator|coordinator.user}.include? self
  end
  def is_cooperator? (event)
    event.cooperators.collect{|cooperator|cooperator.user}.include? self
  end

  private
  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while User.where(id: self.id).exists?
  end
end
