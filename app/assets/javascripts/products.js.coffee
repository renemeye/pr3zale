# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $(".more-products").click ->
    $this = $(this)
    $selling = $this.closest(".selling")
    $sells = $selling.find(".sells")
    form_name = $selling.data("name")
    product_id = $selling.data("product-id")
    max_pieces = $selling.data("max-pieces")
    unless max_pieces != false && $sells.find(".product").length >= max_pieces
      $sells.append("<span class='product fa fa-ticket'><input name='#{form_name}' type='hidden' value='#{product_id}'></span>")
  $(".less-products").click ->
    $this = $(this)
    $sells = $this.closest(".selling").find(".sells")
    $sells.find(".product:last").remove()
  $(".sold-to").click ->
    unless $(this).hasClass("open")
      $(".sold-to").addClass("open")
    else
      $(".sold-to").removeClass("open")


$(document).ready(ready)
$(document).on('page:load', ready)
