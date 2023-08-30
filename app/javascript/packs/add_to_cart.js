var carts = {};
var restid = 0;

function getRestIdFromUrl() {
  var urlParts = window.location.pathname.split("/");
  var restIdIndex = urlParts.indexOf("resturants") + 1;
  return urlParts[restIdIndex];
}

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
function updateConfirmButtonStatus() {
  var cartItemCount = carts[restid] ? Object.keys(carts[restid]).length : 0;
  var confirmButton = $("#checkout");

  if (cartItemCount > 0) {
    confirmButton.prop("disabled", false);
    confirmButton.text("Confirm items");
  } else {
    confirmButton.prop("disabled", true);
    confirmButton.text("Add some items");
  }
}

$(document).on("click", ".submit-order", function () {
  var orderItem = $(this).closest(".order-item");
  var quantity = orderItem.find(".order-quantity").val();
  var id = $(this).val();
  var price = parseFloat(orderItem.find(".card-text").text());
  var name = orderItem.find(".foodname").text();

  if (!carts[restid]) {
    carts[restid] = {};
  } else if (carts[restid][id]) {
    alert("items already added to cart");
  }

  var item = {
    q: parseInt(quantity),
    p: price,
    n: name,
  };
  carts[restid][id] = item;

  updateCartItemCount();
  updateCart();
  updateConfirmButtonStatus();

  $("#cart-btn").addClass("glow-animation");
  setTimeout(function () {
    $("#cart-btn").removeClass("glow-animation");
  }, 5000);
});

$(document).on("click", ".remove-item", function () {
  var itemKey = $(this).data("item-key");
  delete carts[restid][itemKey];
  $("#" + itemKey).remove();
  updateCart();
  updateConfirmButtonStatus();
});

$(document).on("input", ".order-quantity", function () {
  var newQuantity = parseInt($(this).val());
  var itemKey = $(this).data("item-key");

  if (carts[restid] && carts[restid][itemKey]) {
    var item = carts[restid][itemKey];
    item.q = newQuantity;

    var itemPrice = item.q * item.p;
    $(this)
      .closest(".cart-item")
      .find(".item-price")
      .text("Price: Rs. " + itemPrice.toFixed(2));

    // updateCartItemCount();
    updateCart();
    // updateConfirmButtonStatus();
  }
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

      var cartItemHtml = `
          <div class="cart-item shadow p-3 mb-5 bg-body rounded" id="${itemKey}">
            <li class="list-group-item">Food Name: <strong>${
              item.n
            }</strong></li>
            <div class="quantity-input">
              Quantity: 
              <input type="number" class="order-quantity" value="${
                item.q
              }" min="1" max="20" data-item-key="${itemKey}" onkeydown="return false">
            </div>
            <li class="list-group-item">Price: Rs. ${itemPrice.toFixed(2)}</li>
            <button class="remove-item btn btn-danger btn-sm" data-item-key="${itemKey}">Remove</button>
          </div>`;

      $("#cart-items").append(cartItemHtml);
    });
  }

  $("#total-quantity").text(totalQuantity);
  $("#total-price").text("Total Price: Rs " + totalPrice.toFixed(2));

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
