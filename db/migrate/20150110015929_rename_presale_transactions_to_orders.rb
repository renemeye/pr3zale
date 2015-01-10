class RenamePresaleTransactionsToOrders < ActiveRecord::Migration
  def change
    rename_table :presale_transactions, :orders
  end
end
