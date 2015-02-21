class AddSortOrderToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sort_order, :integer, :null => false, :default => 0
    Product.all.each do |p|
      p.sort_order = p.id * 10
      p.save
    end
  end
end
