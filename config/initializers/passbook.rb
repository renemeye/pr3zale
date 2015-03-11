require 'passbook'

Passbook.configure do |passbook|
  passbook.wwdc_cert = Rails.root.join('config','WWDR.pem')
  passbook.p12_key = Rails.root.join('config','passkey.pem')
  passbook.p12_certificate = Rails.root.join('config','passcertificate.pem')
  passbook.p12_password = ENV['APPLE_CERTIFICATE_PASSWORD']
end
