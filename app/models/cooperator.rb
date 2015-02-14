class Cooperator < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  scope :coordinators, -> {where(:role => :coordinator)}

  def self.ROLES
    [
      :cooperator,
      :coordinator
    ]
  end
end
