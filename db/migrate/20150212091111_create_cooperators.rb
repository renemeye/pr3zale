class CreateCooperators < ActiveRecord::Migration
  def change
    create_table :cooperators do |t|
      t.references :user, index: true
      t.references :event, index: true
      t.string :nickname
      t.string :role

      t.timestamps
    end
  end
end
