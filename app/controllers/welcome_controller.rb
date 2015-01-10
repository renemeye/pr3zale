class WelcomeController < ApplicationController
  skip_authorization_check
  def index
    @events = Event.all
  end

  def show
    if current_user
      @orders=current_user.orders.on_event(@event)
    end
  end
end
