$("#change_pic").click(function () {
  console.log("clicked");
  $("#take_pic").trigger("click");
  $("#take_pic").on("change", function (e) {
    if (e.target.files.length > 0) {
      $("#submit_btn").trigger("click");
    }
  });
});
