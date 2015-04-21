class AddStateChangeInformationToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :paid_by_user_id, :integer
    add_column :orders, :paid_at, :datetime
    add_column :orders, :canceled_by_user_id, :integer
    add_column :orders, :canceled_at, :datetime
    add_column :orders, :repaid_by_user_id, :integer
    add_column :orders, :repaid_at, :datetime

    Order.all.each do |order|
      order.update paid_at: order.updated_at if order.paid?
      order.update canceled_at: order.updated_at if order.canceled?
    end
  end
end
