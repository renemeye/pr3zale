class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_filter :load_event

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  private

  def load_event
    if request.subdomain.present? and request.subdomain != 'www'
      @event = Event.find_by_slack!(request.subdomain)
    end
  end

  def current_event
    @current_user ||= load_event
  end
  helper_method :current_event
end
