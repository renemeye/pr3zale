class ValidationController < ApplicationController
  authorize_resource :class => Event

  def index
    @qr = RQRCode::QRCode.new( validation_index_url, :size => 4, :level => :h )
  end
end
