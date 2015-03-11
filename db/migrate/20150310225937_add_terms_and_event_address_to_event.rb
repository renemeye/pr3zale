class AddTermsAndEventAddressToEvent < ActiveRecord::Migration
  def change
    add_column :events, :terms, :text
    add_column :events, :event_address, :text
  end
end
