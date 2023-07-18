// change picture for user
$("#change_pic").click(function () {
  console.log("clicked");
  $("#take_pic").trigger("click");
  $("#take_pic").on("change", function (e) {
    if (e.target.files.length > 0) {
      $("#submit_btn").trigger("click");
    }
  });
});

//make admin
$(".make_admin").click(function () {
  makeadmin($(this).val());
});

function makeadmin(idata) {
  $.ajax({
    url: "/makeadmin",
    method: "POST",
    data: {
      id: idata,
      authenticity_token: $('meta[name="csrf-token"]').attr("content"),
    },
    success: function (data) {},
    error: function (data) {},
  });
}

// auto remove flash
$(document).ready(function(){
  setTimeout(function(){
    $('#flash').fadeOut();
  }, 2000);
 })

//mark read notifications
$(".mark-read").click(function () {
  markread($(this).val());
});

function markread(idata) {
  console.log(idata);
  $.ajax({
    url: "/markread",
    method: "POST",
    data: {
      id: idata,
      authenticity_token: $('meta[name="csrf-token"]').attr("content"),
    },
    success: function (data) {
      alert("Marked as read successfully!");
    },
    error: function (data) {},
  });
}

//adding cart items
var cart = {};
let restid = 0;
$(".submit-order").click(function () {
  $("#submit-cart").removeAttr("style");
  var orderItem = $(this).closest(".order-item");
  var quantity = orderItem.find(".order-quantity").val();
  var id = orderItem.find(".submit-order").val();
  var price = orderItem.find(".card-text").text();
  var name = orderItem.find(".foodname").text();
  var resturantid = orderItem.find(".restid").text();
  restid = resturantid;
  var item = {
    q: quantity,
    p: price,
    n: name,
  };
  cart[id] = item;
  updateCart();
});

function updateCart() {
  localStorage.setItem("cart", JSON.stringify(cart));
  $("#cart-items").empty();
  var totalQuantity = 0;
  var totalPrice = 0;

  Object.keys(cart).forEach((item) => {
    var itemPrice = cart[item].q * cart[item].p;
    totalQuantity += cart[item].q;
    totalPrice += itemPrice;

    var cartItemHtml =
      '<div class="cart-item">' +
      '<li class="list-group-item">Food Name: <strong>' +
      cart[item].n +
      "</strong></li>" +
      '<li class="list-group-item">Quantity: ' +
      cart[item].q +
      "</li>" +
      '<li class="list-group-item"> <strong> Price: Rs.' +
      itemPrice +
      "</strong></li>" +
      "</div>";

    $("#cart-items").append(cartItemHtml);
  });

  $("#total-quantity").text(totalQuantity);
  $("#total-price").text("Rs" + totalPrice.toFixed(2));
}

$("#checkout").click(function () {
  localStorage.removeItem("cart");
  
  $.ajax({
    url: "/resturants/" + restid + "/orders",
    method: "POST",
    data: {
      cart_items: cart,
      authenticity_token: $('meta[name="csrf-token"]').attr("content"),
    },
    success: function (response) {
      alert("Added to cart successfully!");
    },
    error: function (xhr, status, error) {
      alert("Error placing the order. Please try again.");
    },
  });
});

// order edit
$(document).ready(function() {
  var initialquantity = $('.quantity input[type="number"]');
  var initialinput = $('input[name="order[total]"]');
  var initalprice = $('.quantity .newprice');

  initialquantity.on('change', function() {
    updateTotal();
  });

  function updateTotal() {
    var total = 0;
    initialquantity.each(function(index) {
      var quantity = parseInt($(this).val());
      var price = parseFloat(initalprice.eq(index).data('price'));
      total += quantity * price;
    });
    initialinput.val(total.toFixed(2));
  }
});

// rating 
$('.rating-form span').click(function(){
  var value = $(this).attr("data-value");
  $(".rating").val(value);
  $(this).siblings("span").removeClass("bi-star-fill").addClass("bi-star");
  $(this).removeClass("bi-star").addClass("bi-star-fill");
  $(this).prevAll("span").removeClass("bi-star").addClass("bi-star-fill");
});

//approve review
$('.approve').click(function(){
  approvereview($(this).val())
})

function approvereview(review_id){
  console.log(review_id);
  var id = $('#restvalue').attr("value");
  console.log(id);
  $.ajax({

    url: '/resturants/'+id+'/approve',
    method: 'POST',
    data:{id: review_id,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success: function(data){

    },
    error: function(data){

    },


  })
}