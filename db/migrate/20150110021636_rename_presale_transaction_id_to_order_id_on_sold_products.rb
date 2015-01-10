class RenamePresaleTransactionIdToOrderIdOnSoldProducts < ActiveRecord::Migration
  def change
    rename_column :sold_products, :presale_transaction_id, :order_id
  end
end
