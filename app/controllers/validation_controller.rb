class ValidationController < ApplicationController
  skip_authorization_check
  before_filter :get_cooperator

  def index
    authorize! :validate_tickets, @event
    prefill_mail = current_user.email if current_user
    for i in 1..15
      begin
        return @qr = RQRCode::QRCode.new( validation_index_url(:email => prefill_mail), :size => i, :level => :h )
      rescue RQRCode::QRCodeRunTimeError
        next
      end
      return @qr unless @qr.nil?
    end
  end

  def show
    authorize! :validate_tickets, @event
    sold_product = SoldProduct.find(params[:sold_product_id])

    if sold_product && Devise.secure_compare(sold_product.verification_token, params[:verification_token])
      @sold_product = sold_product
      @valid = true
    else
      @sold_product = nil
      @valid = false
    end
  end

  def issue
    authorize! :validate_tickets, @event
    sold_product = SoldProduct.find(params[:sold_product_id])
    if sold_product && Devise.secure_compare(sold_product.verification_token, params[:verification_token]) && sold_product.can_use?
      sold_product.use
    end
    redirect_to validation_index_path, :notice => "Successfully used '#{sold_product.name}';"
  end

private
  def get_cooperator
    @cooperator = current_user.cooperations.where(event: @event).first if current_user
  end

end
