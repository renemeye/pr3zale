class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :transfer_token
      t.string :validation_token
      t.string :state
      t.references :event, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
