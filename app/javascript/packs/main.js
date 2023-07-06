$('#change_pic').click(function(){
    console.log('clicked')
    $('#take_pic').trigger('click')
    $('#take_pic').on('change',function(e){
      if(e.target.files.length>0){
        $('#submit_btn').trigger('click');
      }   
    })
})


$('.make_admin').click(function(){
  makeadmin($(this).val())
})

function makeadmin(idata){
  $.ajax({

    url: '/makeadmin',
    method: 'POST',
    data:{id: idata,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success: function(data){

    },
    error: function(data){

    },


  })
}

// function fetchNotificationsCount() {
//   const notificationBadge = document.getElementById("notification-count");

//   fetch("/notifications/count")
//     .then((response) => response.json())
//     .then((data) => {
//       console.log(data.count);
//       notificationBadge.innerText = data.count;
//     });
// }


$('.mark-read').click(function(){
  markread($(this).val())
})

function markread(idata){
  console.log(idata);
  $.ajax({

    url: '/markread',
    method: 'POST',
    data:{id: idata,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success: function(data){

    },
    error: function(data){

    },


  })
}