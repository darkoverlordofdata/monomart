#
# coffee/shopping/index.coffee
#	
updateCart = (id, qty, price) ->
  $.post("/Cart/Update",  "productId": id, "quantity": qty, "price": price ,
    (data) ->
      $("#message").addClass("alert alert-success")
      $("#message").html("Order updated")
      if (ref = $("#product0" + id)) isnt null
        if ref.modal isnt null
          ref.modal 'hide'
      
  ).fail ->
    $("#message").addClass("alert alert-warning")
    $("#message").html("Your order did not update")
    if (ref = $("#product0" + id)) isnt null
      if ref.modal isnt null
        ref.modal 'hide'
  


$(".update-cart").bind 'click', (e) ->
  if e.target.nodeName is 'BUTTON'
    $select = $(this).find('select')
    updateCart $select.attr('data-id'), $select.val(), $select.attr('data-price')


