# encoding: utf-8
class SoldProductPdf < Prawn::Document
  def initialize(sold_product, event, validation_url)
    super(top_margin: 70)
    @sold_product = sold_product
    @event = event
    @validation_url = validation_url
    heading
    date
    qr_code
    product
    author
    kleinbetragsrechnung
  end

  def heading
    text "Online Ticket & Quittung \##{@sold_product.id}", style: :bold, size: 30
  end

  def date
    text "#{I18n.l @sold_product.created_at.to_date}"
  end

  def qr_code
    text "Validation Token: #{@sold_product.verification_token}"
    move_down 200
    render_qr_code(@sold_product.qr(@validation_url), :dot=>2.8)
  end

  def author
    text "#{@event.company_name}, #{@event.company_address}"
  end

  def kleinbetragsrechnung
    text "Dieses Ticket gilt gleichzeitig als Kleinbetragsrechnung im Sinne vom §33 UStDV. Umtausch und Rückgabe ausgeschlossen."
  end

  def product
    text "#{@sold_product.name} #{ActionController::Base.helpers.number_to_currency @sold_product.price} (inkl. #{ActionController::Base.helpers.number_to_currency @sold_product.tax_price} MwSt.)"
  end

end
