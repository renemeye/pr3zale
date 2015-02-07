class ValidationController < ApplicationController
  authorize_resource :class => Event

  def index
    prefill_mail = current_user.email if current_user
    @qr = RQRCode::QRCode.new( validation_index_url(:email => prefill_mail), :size => 6, :level => :h )
  end

  def show
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
    sold_product = SoldProduct.find(params[:sold_product_id])
    if sold_product && Devise.secure_compare(sold_product.verification_token, params[:verification_token]) && sold_product.can_use?
      sold_product.use
    end
    redirect_to validation_index_path, :notice => "Successfully used '#{sold_product.product.name}';"
  end

end
