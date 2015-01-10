class CookiePolicyController < ApplicationController
  skip_authorization_check
  skip_before_filter :verify_authenticity_token
  def allow
    response.set_cookie 'rack.policy', {
      value: 'true',
      path: '/',
      expires: 1.year.from_now.utc
    }
    redirect_to root_url, :info => "Allowed Cookies"
  end

  def deny
    response.delete_cookie 'rack.policy'
    redirect_to root_url, :error => "Denied Cookies. We need Cookies on this page."
  end
end
