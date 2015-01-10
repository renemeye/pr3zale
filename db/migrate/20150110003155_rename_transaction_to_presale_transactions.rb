class RenameTransactionToPresaleTransactions < ActiveRecord::Migration
  def change
    rename_table :transactions, :presale_transactions
  end
end
