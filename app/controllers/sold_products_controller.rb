# encoding: utf-8
class SoldProductsController < ApplicationController
  load_and_authorize_resource

  def show
    respond_to do |format|
      format.pdf do
        pdf = SoldProductPdf.new(@sold_product, @event, request.host)
        send_data pdf.render, filename: "#{@event.slack}-#{@sold_product.id}-#{@sold_product.name.parameterize}.pdf",
                              type: "application/pdf"
      end

      format.pkpass do
        validation_url = Rails.application.routes.url_helpers.validation_url(
          :host => request.host,
          :sold_product_id => @sold_product.id,
          :verification_token => @sold_product.verification_token,
          :script_name => ENV['RAILS_RELATIVE_URL_ROOT']
        )
        pass = JSON.parse("{
                'formatVersion': 1,
                'teamIdentifier' : '#{ENV['APPLE_TEAM_IDENTIFIER']}',
                'passTypeIdentifier' : '#{ENV['PASSBOOK_PASS_TYPE_IDENTIFIER']}',
                'serialNumber' : '#{@sold_product.id}',
                'organizationName' : 'foo',
                'description' : 'foo'
              }".gsub('\'','"')).to_json
        passbook = Passbook::PKPass.new pass

        FileUtils.cp Paperclip.io_adapters.for(@event.passbook_icon).path, icon = File.join("public", "icon.png")
        FileUtils.cp Paperclip.io_adapters.for(@event.passbook_icon_2x).path, icon2x = File.join("public", "icon@2x.png")
        # FileUtils.cp Paperclip.io_adapters.for(@event.passbook_icon).path, logo = File.join("public", "logo.png")
        # FileUtils.cp Paperclip.io_adapters.for(@event.passbook_icon_2x).path, logo2x = File.join("public", "logo@2x.png")
        # FileUtils.cp Paperclip.io_adapters.for(@event.passbook_background).path, background = File.join("public", "background.png")
        # FileUtils.cp Paperclip.io_adapters.for(@event.passbook_background_2x).path, background2x = File.join("public", "background@2x.png")

        FileUtils.cp Paperclip.io_adapters.for(@sold_product.former_product.images.first.image.styles[:thumb]).path, thumbnail = File.join("public", "thumbnail.png") if @sold_product.former_product.images.length > 0

        passbook.addFiles [
          icon,
          icon2x,
          # logo,
          # logo2x,
          # background,
          # background2x
        ]
        File.open(passbook.file(filename: ['pass', 'pkpass']).path, 'rb') do |f|
          send_data f.read, type: 'application/vnd.apple.pkpass', filename: "pass.pkpass", :disposition => "attachment"
        end
      end
    end
  end
end
