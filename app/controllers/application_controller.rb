class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_filter :load_event
  before_filter :set_locale
  before_filter :check_for_new_cooperators
  skip_before_filter :check_for_new_cooperators, if: :devise_controller?

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

  # def current_event
  #   @current_user ||= load_event
  # end
  # helper_method :current_event
  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
    # current_user.locale
    # request.subdomain
    # request.env["HTTP_ACCEPT_LANGUAGE"]
    # request.remote_ip
  end

  def check_for_new_cooperators
    if current_user && current_user.is_cooperator?(@event)
      cooperation = current_user.cooperations.where(event: @event).first
      if cooperation && (cooperation.anti_phishing_secret.blank? || cooperation.nickname.blank?)
        redirect_to edit_phishing_data_cooperator_path(cooperation)
      end
    end
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end
end
