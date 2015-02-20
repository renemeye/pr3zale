class UserMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def confirmation_instructions(record, token, opts={})
    @resource = record
    @token = token
    # set_locale(@user)
    mail to: @resource.email, subject: t("devise.mailer.confirmation_instructions.subject")
  end

  def reset_password_instructions(user)
    @user = user
    # set_locale(@user)
    mail to: @user.email
  end

  def unlock_instructions(user)
    @user = user
    # set_locale(@user)
    mail to: @user.email
  end

  # private
  #  def set_locale(user)
  #    I18n.locale = user.locale || I18n.default_locale
  #  end
end
