class AddAntiPhishingSecretToCooperators < ActiveRecord::Migration
  def change
    add_column :cooperators, :anti_phishing_secret, :string
  end
end
