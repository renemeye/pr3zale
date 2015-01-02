class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.float :tax
      t.text :description
      t.integer :quantity

      t.timestamps
    end
  end
end
