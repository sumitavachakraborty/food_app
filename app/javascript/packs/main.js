//make admin
$(".make_admin").click(function () {
  makeadmin($(this).val());
});

function makeadmin(idata) {
  console.log(idata);
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
  }, 5000);
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

//change address
$(document).on("click", "#change-address", function (event) {
  event.preventDefault();
});

$(document).ready(function () {
  var myModal = new bootstrap.Modal(document.getElementById("addressModal"));

  $("#saveAddressBtn").on("click", function () {
    var newAddress = $("#newAddress").val();
    var newPincode = $("#newPincode").val();

    var addressPattern = /^(?=.*[A-Za-z])[0-9A-Za-z\s,./-]+$/;
    var pincodePattern = /^\d{6}$/;
    var isAddressValid = addressPattern.test(newAddress);
    var isPincodeValid = pincodePattern.test(newPincode);

    if (!isAddressValid) {
      $("#addressValidationError").text("Invalid address format.");
    } else {
      $("#addressValidationError").text("");
    }

    if (!isPincodeValid) {
      $("#pincodeValidationError").text("Invalid pincode format.");
    } else {
      $("#pincodeValidationError").text("");
    }

    if (isAddressValid && isPincodeValid) {
      $("#order_delivery_address").val(newAddress + ", " + newPincode);
      myModal.hide();
    }
  });
});

//review image
$(document).ready(function() {
  $('#review_images_field').on('change', function(e) {
    var files = e.target.files;
    $('#image-preview').empty(); 

    for (var i = 0; i < files.length; i++) {
      var file = files[i];
      var reader = new FileReader();

      reader.onload = function(e) {
        var imageSrc = e.target.result;
        var imagePreview = `
          <div>
            <img src="${imageSrc}" alt="Selected Image" style="max-width: 150px; max-height: 150px;">
          </div>
        `;

        $('#image-preview').append(imagePreview);
      };

      reader.readAsDataURL(file);
    }
  });
});