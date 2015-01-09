class CreateSoldProducts < ActiveRecord::Migration
  def change
    create_table :sold_products do |t|
      t.references :product, index: true
      t.string :state
      t.references :transaction, index: true

      t.timestamps
    end
  end
end
