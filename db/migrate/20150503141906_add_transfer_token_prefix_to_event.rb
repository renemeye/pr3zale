class AddTransferTokenPrefixToEvent < ActiveRecord::Migration
  def change
    add_column :events, :transfer_token_prefix, :string
  end
end
