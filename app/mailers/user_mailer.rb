class UserMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def confirmation_instructions(record, token, opts={})
    @resource = record
    @token = token
    mail to: @resource.email, subject: t("devise.mailer.confirmation_instructions.subject")
  end

  def reset_password_instructions(record, token, opts={})
    @resource = record
    @token = token
    mail to: @resource.email, subject: t("devise.mailer.reset_password_instructions.subject")
  end

  def unlock_instructions(record, token, opts={})
    @resource = record
    @token = token
    mail to: @resource.email, subject: t("devise.mailer.unlock_instructions.subject")
  end

  # private
  #  def set_locale(user)
  #    I18n.locale = user.locale || I18n.default_locale
  #  end
end
