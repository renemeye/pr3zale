class OrdersController < ApplicationController
  load_and_authorize_resource :through => :event

  respond_to :html

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    flash[:error] = "You must select one product at least."
    redirect_to "/products/"
  end

  def create
    @order = Order.new(order_params)
    @order.event = @event
    @order.user = current_user
    if @order.save
      respond_with(@order)
    else
      flash[:error] = "Some of the requested products are sold out."
      redirect_to products_path
    end
  end

  def show
    respond_with(@order)
  end

  def destroy
    @order.cancel
    respond_with(@order)
  end

  private

    def order_params
      params.require(:order).permit(:state,  {:sold_products_attributes => [:product_id]})
    end
end
