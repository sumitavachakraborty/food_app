var carts = {};
var restid = 0;
var itemAddedToCart = false;

$(document).ready(function () {
  initializeCarts();
});

function initializeCarts() {
  if (localStorage.getItem("carts")) {
    carts = JSON.parse(localStorage.getItem("carts"));
    restid = getRestIdFromUrl();
    updateCartItemCount();
    updateCart();
  }
}

function getRestIdFromUrl() {
  var urlParts = window.location.pathname.split("/");
  var restIdIndex = urlParts.indexOf("resturants") + 1;
  return urlParts[restIdIndex];
}

$(".submit-order").click(function () {
  var orderItem = $(this).closest(".order-item");
  var quantity = orderItem.find(".order-quantity").val();
  var id = orderItem.find(".submit-order").val();
  var price = parseFloat(orderItem.find(".card-text").text());
  var name = orderItem.find(".foodname").text();

  if (!carts[restid]) {
    carts[restid] = {};
  }

  var item = {
    q: parseInt(quantity),
    p: price,
    n: name,
  };
  carts[restid][id] = item;

  itemAddedToCart = true;
  updateCartItemCount();
  updateCart();
  alert("Added to cart successfully");
});

$(document).on("click", ".remove-item", function () {
  var itemKey = $(this).data("item-key");
  delete carts[restid][itemKey];
  updateCart();
});

function updateCartItemCount() {
  var cartItemCount = carts[restid] ? Object.keys(carts[restid]).length : 0;
  $("#cart-item-count").text(cartItemCount);
}

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
        itemPrice.toFixed(2) +
        "</strong></li>" +
        '<button class="remove-item btn btn-danger btn-sm" data-item-key="' +
        itemKey +
        '">Remove</button>' +
        "</div>";

      $("#cart-items").append(cartItemHtml);
    });
  }

  $("#total-quantity").text(totalQuantity);
  $("#total-price").text("Rs " + totalPrice.toFixed(2));

  updateCartItemCount();
}

$("#checkout").click(function () {
  localStorage.setItem("carts", JSON.stringify(carts));

  $.ajax({
    url: "/resturants/" + restid + "/orders",
    method: "POST",
    data: {
      cart_items: carts[restid],
      authenticity_token: $('meta[name="csrf-token"]').attr("content"),
    },
    success: function (response) {
      delete carts[restid];
      updateCartItemCount();
      updateCart();
      alert("Submitted order successfully!");
    },
    error: function (xhr, status, error) {
      alert("Please add items to the cart");
    },
  });
});
