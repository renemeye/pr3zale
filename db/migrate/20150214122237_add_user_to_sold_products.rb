class AddUserToSoldProducts < ActiveRecord::Migration
  def change
    add_reference :sold_products, :user, index: true

    SoldProduct.all.each do |sold_product|
      sold_product.user_id = sold_product.order.user_id
      sold_product.save
    end
  end
end
