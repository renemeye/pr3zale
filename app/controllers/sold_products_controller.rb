# encoding: utf-8
class SoldProductsController < ApplicationController
  load_and_authorize_resource

  def show
    respond_to do |format|
      format.pdf do
        pdf = SoldProductPdf.new(@sold_product, @event, request.host, request.protocol)
        send_data pdf.render, filename: "#{@event.slack}-#{@sold_product.id}-#{@sold_product.name.parameterize}.pdf",
                              type: "application/pdf"
      end

      format.pkpass do
        validation_url = Rails.application.routes.url_helpers.validation_url(
          :host => request.host,
          :protocol => request.protocol,
          :sold_product_id => @sold_product.id,
          :verification_token => @sold_product.verification_token,
          :script_name => ENV['RAILS_RELATIVE_URL_ROOT']
        )

        webservice_url = Rails.application.routes.url_helpers.root_url(
          :host => request.host,
          :protocol => request.protocol,
          :script_name => ENV['RAILS_RELATIVE_URL_ROOT']
        )

        pass = JSON.parse("{
              'formatVersion': 1,
              'teamIdentifier' : '#{ENV['APPLE_TEAM_IDENTIFIER']}',
              'passTypeIdentifier' : '#{ENV['PASSBOOK_PASS_TYPE_IDENTIFIER']}',
              'serialNumber' : '#{@sold_product.id}',
              'webserviceURL' : '#{webservice_url}',
              'authenticationToken' : '#{@sold_product.verification_token}',
              'barcode' : {
                'message' : '#{validation_url}',
                'format' : 'PKBarcodeFormatQR',
                'messageEncoding' : 'iso-8859-1'
              },
              'organizationName' : '#{@event.name}-#{@sold_product.name}',
              'description' : '#{@sold_product.name}',
              'logoText': '#{@event.name}',
              'forgroundColor' : 'rgb(255,255,255)',
              'backgroundColor' : '#251C16',
              'locations' : [
                {
                  'latitude': 52.26955,
                  'longitude': 10.51849,
                  'relevantText': 'Kinder- und Jugendzentrum Mühle',
                  'maxDistance': 200
                }
              ],
              'eventTicket' : {
                'primaryFields' : [
                  {
                    'key' : 'ticket',
                    'value' : '#{@sold_product.name}'
                  }
                ],
                'secondaryFields' : [
                  {
                    'key' : 'price',
                    'label': 'Price',
                    'value' : '#{ActionController::Base.helpers.number_to_currency  @sold_product.price}'
                  }
                ],
                'backFields' : [
                  {
                    'key' : 'loc',
                    'label' : 'LOCATION',
                    'value' : '#{@event.event_address}'
                  },
                  {
                    'key' : 'verification',
                    'label' : 'Verification',
                    'value' : '#{@sold_product.id}\\n#{@sold_product.verification_token}'
                  },
                  {
                    'key' : 'productdescription',
                    'label' : 'Product Description',
                    'value' : #{@sold_product.description.to_json}
                  },
                  {
                    'key' : 'terms',
                    'label' : 'Code of Conduct',
                    'value' : #{@event.terms.to_json}
                  },
                  {
                    'key' : 'organizationName',
                    'label' : 'Organization',
                    'value' : '#{@event.company_name}\\n#{@event.company_address}'
                  }
                ]
              }
          }".gsub('\'','"')).to_json
        passbook = Passbook::PKPass.new pass

        FileUtils.cp Paperclip.io_adapters.for(@event.passbook_icon).path, icon = File.join("public", "icon.png")
        FileUtils.cp Paperclip.io_adapters.for(@event.passbook_icon_2x).path, icon2x = File.join("public", "icon@2x.png")
        FileUtils.cp Paperclip.io_adapters.for(@event.passbook_icon).path, logo = File.join("public", "logo.png")
        FileUtils.cp Paperclip.io_adapters.for(@event.passbook_icon_2x).path, logo2x = File.join("public", "logo@2x.png")
        FileUtils.cp Paperclip.io_adapters.for(@event.passbook_background).path, background = File.join("public", "background.png")
        FileUtils.cp Paperclip.io_adapters.for(@event.passbook_background_2x).path, background2x = File.join("public", "background@2x.png")

        passbook.addFiles [
          icon,
          icon2x,
          logo,
          logo2x,
          background,
          background2x
        ]

        if @sold_product.former_product.images.length > 0
          FileUtils.cp Paperclip.io_adapters.for(@sold_product.former_product.images.first.image.styles[:thumb]).path, thumbnail = File.join("public", "thumbnail.png")
          passbook.addFiles [thumbnail]
        end

        send_data passbook.stream.string.force_encoding("utf-8"), type: 'application/vnd.apple.pkpass', filename: "pass.pkpass", :disposition => "attachment"
      end
    end
  end
end
