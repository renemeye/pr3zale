class ProductsController < ApplicationController
  skip_authorization_check
  before_filter :set_product, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @products = @event.products.all
    respond_with(@products)
  end

  def show
    respond_with(@product)
  end

  def new
    authorize! :manage, @event
    @product = Product.new
    @product.event = @event
    respond_with(@product)
  end

  def edit
    authorize! :manage, @event
  end

  def create
    authorize! :manage, @event
    @product = Product.new(product_params)
    @product.event = @event
    @product.save
    respond_with(@product)
  end

  def update
    authorize! :manage, @event
    @product.update(product_params)
    respond_with(@product)
  end

  def destroy
    authorize! :manage, @event
    @product.destroy
    respond_with(@product)
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :price, :tax, :description, :quantity, :sort_order)
    end
end
