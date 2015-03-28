module Passbook
  class PassbookNotification

    # This is called whenever a new pass is saved to a users passbook or the
    # notifications are re-enabled.  You will want to persist these values to
    # allow for updates on subsequent calls in the call chain.  You can have
    # multiple push tokens and serial numbers for a specific
    # deviceLibraryIdentifier.

    def self.register_pass(options)
      throw "foo self.register_pass"
      the_passes_serial_number = options['serialNumber']
      the_devices_device_library_identifier = options['deviceLibraryIdentifier']
      the_devices_push_token = options['pushToken']
      the_pass_type_identifier = options["passTypeIdentifier"]
      the_authentication_token = options['authToken']

      # this is if the pass registered successfully
      # change the code to 200 if the pass has already been registered
      # 404 if pass not found for serialNubmer and passTypeIdentifier
      # 401 if authorization failed
      # or another appropriate code if something went wrong.
      {:status => 201}
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

    # this is called when a pass is deleted or the user selects the option to disable pass updates.
    def self.unregister_pass(options)
      throw "foo self.unregister_pass"
      # a solid unique pair of identifiers to identify the pass are
      serial_number = options['serialNumber']
      device_library_identifier = options['deviceLibraryIdentifier']
      the_pass_type_identifier = options["passTypeIdentifier"]
      the_authentication_token = options['authToken']
      # return a status 200 to indicate that the pass was successfully unregistered.
      {:status => 200}
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
      throw "foo self.passbook_log"
      # this is a VERY crude logging example.  use the logger of your choice here.
      p "#{Time.now} #{log}"
    end

  end
end
