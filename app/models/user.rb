class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :orders
  has_many :cooperations, :class_name => "Cooperator"
  before_create :randomize_id

  def is_coordinator? (event)
    cooperation = self.cooperation(event)
    (not cooperation.nil?) && cooperation.role == "coordinator"
  end
  def is_cooperator? (event)
    not self.cooperation(event).nil?
  end

  def cooperation (event)
    self.cooperations.find_by_event_id(event.id) unless event.nil?
  end

  def to_s(event, visiting_user)
    if visiting_user.is_coordinator?(event)
      if cooperation = self.cooperation(event)
        "#{cooperation.nickname} #{cooperation.role} (#{self.email})"
      else
        "User (#{self.email})"
      end
    else
      if cooperation = self.cooperation(event)
        cooperation.nickname
      else
        "User"
      end
    end
  end

  private
  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while User.where(id: self.id).exists?
  end
end
