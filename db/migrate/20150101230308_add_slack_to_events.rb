class AddSlackToEvents < ActiveRecord::Migration
  def change
    add_column :events, :slack, :string, index: true, null: false, default: ""
  end
end
