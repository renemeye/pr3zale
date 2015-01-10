class SoldProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :order

  def name
    former_product.name
  end

  def price
    former_product.price
  end

  def tax
    former_product.tax
  end

  def description
    former_product.description
  end

  def former_product
    self.product.version_at(self.created_at)
  end
end
