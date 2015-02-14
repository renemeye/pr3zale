class AddEventToSoldProducts < ActiveRecord::Migration
  def change
    add_reference :sold_products, :event, index: true

    SoldProduct.all.each do |sold_product|
      sold_product.event_id = sold_product.product.event_id
      sold_product.save
    end
  end
end
