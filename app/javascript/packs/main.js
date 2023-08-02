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
$(document).ready(function () {
  setTimeout(function () {
    $("#flash").fadeOut();
  }, 2000);
});

//mark read notifications
$(".mark-read").click(function () {
  markread($(this).val());
});

function markread(idata) {
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

$(".notification_count").click(function () {
  count($(this).attr("value"));
});
function count(idata) {
  $.ajax({
    url: "/count",
    method: "POST",
    data: {
      id: idata,
      authenticity_token: $('meta[name="csrf-token"]').attr("content"),
    },
    success: function (data) {},
    error: function (data) {},
  });
}

// order edit
$(document).ready(function () {
  var initialquantity = $('.quantity input[type="number"]');
  var initialinput = $('input[name="order[total]"]');
  var initalprice = $(".quantity .newprice");

  initialquantity.on("change", function () {
    updateTotal();
  });

  function updateTotal() {
    var total = 0;
    initialquantity.each(function (index) {
      var quantity = parseInt($(this).val());
      var price = parseFloat(initalprice.eq(index).data("price"));
      total += quantity * price;
    });
    initialinput.val(total.toFixed(2));
  }
});

// rating
$(".rating-form span").click(function () {
  var value = $(this).attr("data-value");
  $(".rating").val(value);
  $(this).siblings("span").removeClass("bi-star-fill").addClass("bi-star");
  $(this).removeClass("bi-star").addClass("bi-star-fill");
  $(this).prevAll("span").removeClass("bi-star").addClass("bi-star-fill");
});

//approve review
$(".approve").click(function () {
  approvereview($(this).val());
});

function approvereview(review_id) {
  var id = $("#restvalue").attr("value");
  $.ajax({
    url: "/resturants/" + id + "/approve",
    method: "POST",
    data: {
      id: review_id,
      authenticity_token: $('meta[name="csrf-token"]').attr("content"),
    },
    success: function (data) {
      alert("Review successfully approved!");
    },
    error: function (data) {},
  });
}

var carts = {};
var restid = 0;
$(document).ready(function () {
  if (localStorage.getItem("carts")) {
    carts = JSON.parse(localStorage.getItem("carts"));
    restid = getRestIdFromUrl();
    updateCartItemCount();
  }
});

function getRestIdFromUrl() {
  var urlParts = window.location.pathname.split("/");
  var restIdIndex = urlParts.indexOf("resturants") + 1;
  return urlParts[restIdIndex];
}

$("#cart-btn").click(function () {
  updateCart();
});

function updateCartItemCount() {
  var cartItemCount = 0;
  if (carts[restid]) {
    cartItemCount = Object.keys(carts[restid]).length;
    console.log(cartItemCount);
    console.log(carts[restid]);
  }
  $("#cart-item-count").text(cartItemCount);
}

$(".submit-order").click(function () {
  $("#submit-cart").removeAttr("style");
  var orderItem = $(this).closest(".order-item");
  var quantity = orderItem.find(".order-quantity").val();
  var id = orderItem.find(".submit-order").val();
  var price = orderItem.find(".card-text").text();
  var name = orderItem.find(".foodname").text();
  restid = orderItem.find(".restid").text();
  console.log(quantity)
  console.log(restid)
  console.log(id)
  if (!carts[restid]) {
    carts[restid]= {};
  }

  var item = {
    q: quantity,
    p: price,
    n: name,
  };
  console.log(item);
  carts[restid][id] = item;
  console.log(carts[restid][id])
  updateCartItemCount();
  updateCart();
  
});

$(document).on("click", ".remove-item", function () {
  var itemKey = $(this).data("item-key");
  delete carts[restid][itemKey];
  updateCart();
});

function updateCart() {
  localStorage.setItem("carts", JSON.stringify(carts));
  $("#cart-items").empty();
  var totalQuantity = 0;
  var totalPrice = 0;

  if (carts[restid]) {
    Object.keys(carts[restid]).forEach((itemKey) => {
      var item = carts[restid][itemKey];
      var itemPrice = item.q * item.p;
      totalQuantity += item.q;
      totalPrice += itemPrice;

      var cartItemHtml =
        '<div class="cart-item shadow p-3 mb-5 bg-body rounded">' +
        '<li class="list-group-item">Food Name: <strong>' +
        item.n +
        "</strong></li>" +
        '<li class="list-group-item">Quantity: ' +
        item.q +
        "</li>" +
        '<li class="list-group-item"> <strong> Price: Rs.' +
        itemPrice +
        "</strong></li>" +
        '<button class="remove-item btn btn-danger btn-sm" data-item-key="' +
        itemKey +
        '">Remove</button>' +
        "</div>";

      $("#cart-items").append(cartItemHtml);
    });
  }

  $("#total-quantity").text(totalQuantity);
  $("#total-price").text("Rs" + totalPrice.toFixed(2));

  updateCartItemCount();
}

$("#checkout").click(function () {
  localStorage.setItem("carts", JSON.stringify(carts));
  sessionStorage.removeItem("cart");

  $.ajax({
    url: "/resturants/" + restid + "/orders",
    method: "POST",
    data: {
      cart_items: carts[restid],
      authenticity_token: $('meta[name="csrf-token"]').attr("content"),
    },
    success: function (response) {
      alert("Added to cart successfully!");
      updateCartItemCount();
      delete carts[restid];
      localStorage.setItem("carts", JSON.stringify(carts));
    },
    error: function (xhr, status, error) {
      alert("Please add items to the cart");
    },
  });
});
