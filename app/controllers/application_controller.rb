class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_filter :load_event

  private

  def load_event
    if request.subdomain.present? and request.subdomain != 'www'
      @event = Event.find_by_slack!(request.subdomain)
    end
  end
end
