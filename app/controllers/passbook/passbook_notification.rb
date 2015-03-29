module Passbook
  class PassbookNotification

    # This is called whenever a new pass is saved to a users passbook or the
    # notifications are re-enabled.  You will want to persist these values to
    # allow for updates on subsequent calls in the call chain.  You can have
    # multiple push tokens and serial numbers for a specific
    # deviceLibraryIdentifier.

    def self.register_pass(options)
      the_passes_serial_number = options['serialNumber']
      the_devices_device_library_identifier = options['deviceLibraryIdentifier']
      the_devices_push_token = options['pushToken']
      the_pass_type_identifier = options["passTypeIdentifier"]
      the_authentication_token = options['authToken']

      sold_product = SoldProduct.where(id: the_passes_serial_number).first
      if sold_product and the_pass_type_identifier == ENV['PASSBOOK_PASS_TYPE_IDENTIFIER']
        if sold_product.verification_token == the_authentication_token

          if PassbookDeviceRegistration.exists? device_library_identifier: the_devices_device_library_identifier, sold_product_id: sold_product.id
            return {:status => 200}
          else
            registration = PassbookDeviceRegistration.new
            registration.device_library_identifier = the_devices_device_library_identifier
            registration.push_token = the_devices_push_token
            registration.sold_product = sold_product

            if registration.save
              return {:status => 201}
            else
              return {:status => 500}
            end
          end
        else
          return {:status => 401}
        end
      else
        return {:status => 404}
      end

      {:status => 500}
    end

    # this is called when a pass is deleted or the user selects the option to disable pass updates.
    def self.unregister_pass(options)
      # a solid unique pair of identifiers to identify the pass are
      serial_number = options['serialNumber']
      device_library_identifier = options['deviceLibraryIdentifier']
      the_pass_type_identifier = options["passTypeIdentifier"]
      the_authentication_token = options['authToken']

      sold_product = SoldProduct.where(id: serial_number).first
      if sold_product and the_pass_type_identifier == ENV['PASSBOOK_PASS_TYPE_IDENTIFIER']
        if sold_product.verification_token == the_authentication_token
          unregister = PassbookDeviceRegistration.where(device_library_identifier: device_library_identifier, sold_product_id: serial_number).first
          if unregister
            if unregister.destroy!
              return {:status => 200}
            else
              return {:status => 500}
            end
          else
            return {:status => 404}
          end
        else
          return {:status => 401}
        end
      else
        return {:status => 404}
      end


      {:status => 500}
    end

    # This is called when the device receives a push notification from apple.
    # You will need to return the serial number of all passes associated with
    # that deviceLibraryIdentifier.

    def self.passes_for_device(options)
      throw "foo self.passes_for_device"
      device_library_identifier = options['deviceLibraryIdentifier']
      passes_updated_since = options['passesUpdatedSince']

      # the 'lastUpdated' uses integers values to tell passbook if the pass is
      # more recent than the current one.  If you just set it is the same value
      # every time the pass will update and you will get a warning in the log files.
      # you can use the time in milliseconds,  a counter or any other numbering scheme.
      # you then also need to return an array of serial numbers.
      {'lastUpdated' => '1', 'serialNumbers' => ['various', 'serial', 'numbers']}
    end

    # this returns your updated pass
    def self.latest_pass(options)
      throw "foo self.latest_pass"
      the_pass_serial_number = options['serialNumber']
      # create your PkPass the way you did when your first created the pass.
      # you will want to return
      my_pass = PkPass.new 'your pass json'
      # you will want to return the string from the stream of your PkPass object.
      mypass.stream.string
    end

    # This is called whenever there is something from the update process that is a warning
    # or error
    def self.passbook_log(log)
      logger.info log
    end

  end
end
