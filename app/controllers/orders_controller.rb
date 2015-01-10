class OrdersController < ApplicationController
  load_and_authorize_resource :through => :event

  respond_to :html

  def create
    @order = Order.new(order_params)
    @order.event = @event
    @order.save
    respond_with(@order)
  end

  def show
    respond_with(@order)
  end

  private

    def order_params
      params.require(:order).permit(:state,  {:sold_products_attributes => [:product_id]})
    end
end
