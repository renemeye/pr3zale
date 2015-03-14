Test User reminder email:

    rails c
    > user = User.find_by_email "your email address"
    > open_orders = user.orders
    > event = Event.first
    > OrderMailer.payment_reminder(user, open_orders, event).deliver
