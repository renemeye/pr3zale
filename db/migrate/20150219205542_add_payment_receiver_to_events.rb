class AddPaymentReceiverToEvents < ActiveRecord::Migration
  def change
    add_column :events, :payment_receiver, :string
  end
end
