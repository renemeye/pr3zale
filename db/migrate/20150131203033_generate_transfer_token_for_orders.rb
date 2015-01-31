class GenerateTransferTokenForOrders < ActiveRecord::Migration
  def change
    Order.all.each do |order|
      order.generate_transfer_token
      order.save
    end
  end
end
