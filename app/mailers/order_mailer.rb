class OrderMailer < ActionMailer::Base
  #default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.reservation_confirmation.subject
  #
  def reservation_confirmation(user, order)
    @user = user
    @order = order
    @event = order.event

    mail to: user.email, subject: t("order_mailer.event Presale Reservation#order_id", event: order.event.name, order_id: order.id)
  end
end
