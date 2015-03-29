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

  def purchase
    respond_to do |format|
      format.json do
        @order.purchase
        render json: @order
      end
    end
  end

  def show
    respond_to do |format|
      format.pdf do
        raise ActionController::RoutingError.new('Not Found') unless @order.paid?
        pdf = SoldProductPdf.new(@order.sold_products.to_a, @event, request.host, request.protocol)
        send_data pdf.render, filename: "#{@event.slack}-#{@order.id}.pdf",
                              type: "application/pdf"
      end
      format.html do
        respond_with(@order)
      end
    end
  end

  def destroy
    @order.cancel
    respond_with(@order)
  end

  def import_payments_csv
    @entries = Order.import_payments_from_csv(@event, params[:file])
  end

  def remind_open_orders
    @users = @event.orders.open_orders.where("created_at < :ago", {:ago => 2.days.ago}).collect{|o|o.user}.uniq
    @users.each do |user|
      open_orders = user.orders.open_orders.on_event(@event)
      OrderMailer.payment_reminder(user, open_orders, @event).deliver
    end
    redirect_to orders_path, notice: "#{@users.length} users had been reminded." #TODO: Translate
  end

  private

    def order_params
      params.require(:order).permit(:state,  {:sold_products_attributes => [:product_id]})
    end
end
