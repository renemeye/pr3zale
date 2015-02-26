class OrdersController < ApplicationController
  load_and_authorize_resource :through => :event

  respond_to :html

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    flash[:error] = t("products.You must select one product at least")
    redirect_to "/products/"
  end

  def index
    authorize! :mange, @event
    @orders = @event.orders
  end

  def create
    @order = Order.new(order_params)
    @order.event = @event
    @order.user = current_user
    @order.sold_products.each do |sold_product|
      sold_product.user = current_user
      sold_product.event = @event
    end
    if @order.save
      OrderMailer.reservation_confirmation(current_user, @order).deliver
      respond_with(@order)
    else
      flash[:error] = t"orders.Some of the requested products are sold out"
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

  def import_payments_csv
    @entries = Order.import_payments_from_csv(@event, params[:file])
  end

  private

    def order_params
      params.require(:order).permit(:state,  {:sold_products_attributes => [:product_id]})
    end
end
