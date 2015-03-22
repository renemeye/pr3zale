class AddInactiveToProducts < ActiveRecord::Migration
  def change
    add_column :products, :inactive, :boolean

    Product.all.each do |product|
      product.update inactive: false
    end
  end
end
