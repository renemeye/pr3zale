class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :short_description
      t.text :description
      t.integer :owner_id, index: true

      t.timestamps
    end
  end
end
