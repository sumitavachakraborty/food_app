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
$(document).ready(function() {
  $('#search-address').on('input', function() {
    var input = $(this).val();
    var pattern = /^[A-Za-z\s]+$/;
    var searchButton = $('#address-search-btn');

    if (!pattern.test(input)) {
      $('#pattern-validation-message').text('Please enter only letters and spaces.');
      searchButton.prop('disabled', true);
    } else {
      $('#pattern-validation-message').text('');
      searchButton.prop('disabled', false);
    }
  });
});

$('#address-search-btn').click(function(event){
  event.preventDefault();
  let inp=$('#search-address').val()


  const settings = {
    async: true,
    crossDomain: true,
    url: 'https://map-places.p.rapidapi.com/autocomplete/json?input='+inp+'&radius=50000',
    method: 'GET',
    headers: {
      'X-RapidAPI-Key': 'd1cb59beddmshf5c3d4ef7537f14p1983b7jsn55184da528f0',
      'X-RapidAPI-Host': 'map-places.p.rapidapi.com'
    }
  };


  $.ajax(settings).done(function (response) {
  if (response.status=='OK') {

    $('#autocomplete').empty()

    response.predictions.forEach(element => {

      $('#autocomplete').append(`<li><a class="dropdown-item" href="#">${element.description}</a></li>`)

    });

  }
  else{
    alert('An error occurred while fetching')
  }
});

})

$(document).on('click','.dropdown-item',function (event) {
  event.preventDefault();
  let t=$(this).text()
  $('#order_delivery_address').text(t)
  $('#order_delivery_address').val(t)
})

