class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Product
    can :read, Event
    can :read, Image

    unless user.nil?
      can :create, Order
      can :read, Order, :user_id => user.id
      can :read, SoldProduct, :order => {:user_id => user.id}, :state => "downloadable"
      can :destroy, Order, :user_id => user.id

      can :manage, Product do |product|
        user.is_coordinator? product.event
      end
      can :manage, Event do |event|
        user.is_coordinator? event
      end
      can :validate_tickets, Event do |event|
        user.is_cooperator? event
      end
      can :manage, Cooperator do |cooperator|
        user.is_coordinator? cooperator.event
      end
    end


    #can :update, :products

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
