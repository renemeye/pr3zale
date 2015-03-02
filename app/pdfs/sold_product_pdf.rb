# encoding: utf-8
class SoldProductPdf < Prawn::Document
  #include Prawn::View

  def initialize(sold_products, event, host)
    super( page_size: "A5")

    @event = event
    @host = host

    if sold_products.kind_of?(Array)
      sold_products.each do |sold_product|
        @sold_product = sold_product
        create_content
        start_new_page unless sold_product == sold_products.last
      end
    else
      @sold_product = sold_products
      create_content
    end

  end

  def create_content
    @validation_url = Rails.application.routes.url_helpers.validation_url(
      :host => @host,
      :sold_product_id => @sold_product.id,
      :verification_token => @sold_product.verification_token,
      :script_name => ENV['RAILS_RELATIVE_URL_ROOT']
    )

    logo
    move_up 45
    heading
    date
    move_down 50
    product

    qr_code
    author
    kleinbetragsrechnung
  end

  def heading
    text "Online Ticket\n& Quittung", style: :bold, size: 23, align: :right
  end

  def logo
    svg File.open(Paperclip.io_adapters.for(@event.bill_logo).path, "r"), :at => [-50, 550], :width => 250 if @event.bill_logo
  end

  def date
    text "#{I18n.l @sold_product.created_at.to_date}", align: :right
  end

  def qr_code
    move_down 200
    render_qr_code @sold_product.qr(@validation_url), :dot=>3.5
    text "Nummer: #{@sold_product.id}"
    text "Token: #{@sold_product.verification_token}"
  end

  def author
    text_box "#{@event.company_name}, #{@event.company_address}", style: :italic, size: 10, at: [0, 45]
  end

  def kleinbetragsrechnung
    text_box "Dieses Ticket gilt gleichzeitig als Kleinbetragsrechnung im Sinne vom §33 UStDV. Umtausch und Rückgabe ausgeschlossen.", style: :italic, size: 10, at: [0, 30]
  end

  def product
    text "#{@sold_product.name}", size: 20
    text "#{ActionController::Base.helpers.number_to_currency @sold_product.price} (inkl. #{ActionController::Base.helpers.number_to_currency @sold_product.tax_price} MwSt.)", size: 15
  end

end
