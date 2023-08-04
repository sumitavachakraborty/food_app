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

  if (!carts[restid]) {
    carts[restid]= {};
  }

  var item = {
    q: quantity,
    p: price,
    n: name,
  };
  carts[restid][id] = item;
  updateCartItemCount();
  updateCart();
  alert('added to cart successfully');
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
      alert("Submitted order successfully!");
      delete carts[restid];
      localStorage.setItem("carts", JSON.stringify(carts));
    },
    error: function (xhr, status, error) {
      alert("Please add items to the cart");
    },
  });
});
