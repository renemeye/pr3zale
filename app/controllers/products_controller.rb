class ProductsController < ApplicationController
  load_and_authorize_resource :through => :event

  respond_to :html

  def index
    respond_with(@products)
  end

  def show
    respond_with(@product)
  end

  def new
    @product = Product.new
    @product.event = @event
    respond_with(@product)
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    @product.event = @event
    @product.save
    respond_with(@product)
  end

  def update
    @product.update(product_params)
    respond_with(@product)
  end

  def destroy
    @product.destroy
    respond_with(@product)
  end

  private

    def product_params
      params.require(:product).permit(:name, :price, :tax, :description, :quantity)
    end
end
