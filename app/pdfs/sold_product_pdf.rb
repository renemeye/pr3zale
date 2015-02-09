class SoldProductPdf < Prawn::Document
  def initialize(sold_product, event, validation_url)
    super(top_margin: 70)
    @sold_product = sold_product
    @event = event
    @validation_url = validation_url
    heading
    qr_code
  end

  def heading
    text "Sold Product \##{@sold_product.id}", style: :bold, size: 30
  end

  def qr_code
    text "Validation Token: #{@sold_product.verification_token}"
    move_down 200
    render_qr_code(@sold_product.qr(@validation_url), :dot=>2.8)
  end
end
