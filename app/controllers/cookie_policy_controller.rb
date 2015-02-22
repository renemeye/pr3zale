class CookiePolicyController < ApplicationController
  skip_authorization_check
  skip_before_filter :verify_authenticity_token
  def allow

    return_path = params[:return_to] || root_path

    response.set_cookie 'rack.policy', {
      value: 'true',
      path: '/',
      expires: 1.year.from_now.utc
    }
    redirect_to return_path, :info => "Allowed Cookies"
  end

  def deny
    return_path = params[:return_to] || root_path

    response.delete_cookie 'rack.policy'
    redirect_to return_path, :error => "Denied Cookies. We need Cookies on this page."
  end
end
