#
#  coffee/shopping/index.coffee
#

template = null

updateCart = (id, qty, price) ->
  console.log 'updateCart ' + id + ', ' + qty + ', ' + price
  $.post("/Cart/Update", "productId": id, "quantity": qty, "price": price,
    (data) ->
      $("#message").addClass "alert alert-success"
      $("#message").html "Order updated"
      $.post "/Cart", displayCart
      $("#row_" + id)?.modal? "hide"
      $('.modal-backdrop').remove()

  ).fail( ->
    $("#message").addClass "alert alert-warning"
    $("#message").html "Your order did not update"
    $("#row_" + id)?.modal? "hide"
    $('.modal-backdrop').remove()
  )


displayCart = (data) ->

  total = 0
  for item in data
    item.extended = (item.price * item.quantity)
    total += item.extended
  

  $("#cartTable").html template.render(total: total, cart: data)

  $(".update-cart").bind 'click', (e) ->
    if e.target.nodeName is 'BUTTON'
      $select = $(this).find('select')
      updateCart $select.attr('data-id'), $select.val(), $select.attr('data-price')
    
  $(".delete-cart").bind 'click', (e) ->
    if e.target.nodeName is 'BUTTON'
      $this = $(this)
      updateCart $this.attr('data-id'), $this.attr('data-quantity'), '0.00'

  $(".delete-all").bind 'click', (e) ->
    $.post "/Cart/Delete", ->
      $("#message").addClass "alert alert-success"
      $("#message").html "Cart Deleted"
      $.post "/Cart", displayCart

#
# Register a decimal format filter
#
class Filters
	@decimal = (input) ->
  	Number(input).toFixed(2)

Liquid.Template.registerFilter Filters


$.get "/Content/templates/shopping/index.html", (data) ->
  template = Liquid.Template.parse(data)
  $.post "/Cart", displayCart
