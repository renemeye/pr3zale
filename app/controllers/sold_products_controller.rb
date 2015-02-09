class SoldProductsController < ApplicationController
  load_and_authorize_resource

  def show
    respond_to do |format|
      format.pdf do
        @validation_url = Rails.application.routes.url_helpers.validation_url(:host => request.host, :sold_product_id => @sold_product.id, :verification_token => @sold_product.verification_token)

        pdf = SoldProductPdf.new(@sold_product, @event, @validation_url)
        send_data pdf.render, filename: "#{@event.slack}-#{@sold_product.id}-#{@sold_product.name.parameterize}.pdf",
                              type: "application/pdf"
      end
    end
  end
end
