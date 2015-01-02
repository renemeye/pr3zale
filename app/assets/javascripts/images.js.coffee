# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

preload_images = ->
  image_drop = Dropzone.forElement("#new_image")
  imageable_type = $(image_drop.element).data("imageable-type")
  imageable_id = $(image_drop.element).data("imageable-id")

  $.get "/images.json",
  image:
    imageable_type: imageable_type
    imageable_id: imageable_id
  , (data) ->
    $(data).each ->
      # Create the mock file:
      mockFile =
        name: this.image_file_name
        size: this.size
        id: this.id

      # Call the default addedfile event handler
      image_drop.emit "addedfile", mockFile

      # And optionally show the thumbnail of the file:
      image_drop.emit "thumbnail", mockFile, this.url

ready = ->
  Dropzone.autoDiscover = false

	# grap our upload form by its id
  $("#new_image").dropzone
    init: ->
      this.on "addedfile", (file) ->
        $(file.previewElement).find(".dz-remove").attr("data-id", file.id)
      this.on "removedfile", (file) ->
        id = $(file.previewElement).find(".dz-remove").data("id")
        console.log "DELETE #{id}"
        $.ajax
          type: "DELETE"
          url: "/images/" + id
          success: (data) ->
            console.log data.message
    paramName: "image[image]"
    addRemoveLinks: true


  preload_images()

$(document).ready(ready)
$(document).on('page:load', ready)
