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

  #states: :reserved, :downloadable, :issued, :canceled
  state_machine initial: :reserved do
    event :purchase do
      transition :reserved => :downloadable, if: lambda {|sold_product| sold_product.order.paid?}
    end

    event :cancel do
      transition :reserved => :canceled, if: lambda {|sold_product| sold_product.order.canceled?}
    end

    event :use do
      transition :downloadable => :issued
    end

  end

end
