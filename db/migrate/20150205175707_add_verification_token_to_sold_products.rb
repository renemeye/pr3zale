class AddVerificationTokenToSoldProducts < ActiveRecord::Migration
  def change
    add_column :sold_products, :verification_token, :string

    SoldProduct.all.each do |sold_product|
      sold_product.ensure_verification_token
      sold_product.save
    end
  end
end
