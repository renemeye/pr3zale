class AddEventToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :event, index: true
  end
end
