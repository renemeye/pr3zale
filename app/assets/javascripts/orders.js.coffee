# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

silent_reload = ->
  #disable page scrolling to top after loading page content
  Turbolinks.enableTransitionCache(true);

  # pass current page url to visit method
  Turbolinks.visit(location.toString());

  #enable page scroll reset in case user clicks other link
  Turbolinks.enableTransitionCache(false);

ready = ->
  $("a.mark-as-purchased").on "ajax:success", (e, data, status, xhr) ->
    #alert "The order ##{data.id} is marked as purchased."
    silent_reload()

  $("a.mark-as-purchased-no-reload").on "ajax:success", (e, data, status, xhr) ->
    #alert "The order ##{data.id} is marked as purchased (Now: #{data.state})."
    if data.state == "paid"
      $("#order-#{data.id} .state").html("<span class='label label-primary'><span class='fa fa-check'></span> Marked as Paid</span>")
      $("#order-#{data.id} .mark-button").html("")
    else
      $("#order-#{data.id} .state").html("<span class='label label-danger'>Error</span>")


$(document).ready(ready)
$(document).on('page:load', ready)
