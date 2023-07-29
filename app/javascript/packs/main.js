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
