class RenameTransactionIdToPresaleTransactionIdOnSoldProducts < ActiveRecord::Migration
  def change
    rename_column :sold_products, :transaction_id, :presale_transaction_id
  end
end
