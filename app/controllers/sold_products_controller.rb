class SoldProductsController < ApplicationController
  load_and_authorize_resource

  def show
    respond_to do |format|
      format.pdf do
        pdf = SoldProductPdf.new(@sold_product, @event, request.host)
        send_data pdf.render, filename: "#{@event.slack}-#{@sold_product.id}-#{@sold_product.name.parameterize}.pdf",
                              type: "application/pdf"
      end
    end
  end
end
