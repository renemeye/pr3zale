class AddPayUntilToEvents < ActiveRecord::Migration
  def change
    add_column :events, :pay_until, :date
  end
end
