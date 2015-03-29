class CreatePassbookDeviceRegistrations < ActiveRecord::Migration
  def change
    create_table :passbook_device_registrations do |t|
      t.string :device_library_identifier, index: true
      t.string :push_token
      t.references :sold_product, index: true
    end
  end
end
