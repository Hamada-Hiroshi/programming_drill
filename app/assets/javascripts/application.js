// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require jquery.raty
//= require bootstrap-sprockets
//= require_tree .

$(document).on('turbolinks:load', function(){
  $('#myImage').on('change', function (e) {
      var reader = new FileReader();
      reader.onload = function (e) {
          $("#profilePreview").attr('src', e.target.result);
      }
      reader.readAsDataURL(e.target.files[0]);
  });
});


$(document).on('turbolinks:load', function(){
  $('#user-app-contents .tab[id != "learning-tab"]').hide();
});

$(document).on('turbolinks:load', function(){
  $('#user-app-menu a').on('click', function() {
    $("#user-app-contents .tab").hide();
    $("#user-app-menu .active").removeClass("active");
    $(this).addClass("active");
    $($(this).attr("href")).show();
    return false;
  });
});


$(document).on('turbolinks:load', function(){
  $('.category-contents .tag-tab').hide();
});

$(document).on('turbolinks:load', function(){
  $('.category-menu a').on('click', function() {
    $(".category-contents .tab").hide();
    $(".category-menu .active").removeClass("active");
    $(this).addClass("active");
    $($(this).attr("href")).show();
    return false;
  });
});

$(document).on('turbolinks:load', function(){
  $('.category-contents2 .language-tab').hide();
});

$(document).on('turbolinks:load', function(){
  $('.category-menu2 a').on('click', function() {
    $(".category-contents2 .tab").hide();
    $(".category-menu2 .active").removeClass("active");
    $(this).addClass("active");
    $($(this).attr("href")).show();
    return false;
  });
});


$(document).on('turbolinks:load', function(){
  $('#star').raty({
    size: 36,
    starOff: "/assets/star-off.png",
    starOn: "/assets/star-on.png",
    starHalf: "/assets/star-half.png",
    scoreName: 'review[rate]',
    half: true,
  });
});

$(document).on('turbolinks:load', function(){
  var $startEl = $('.star-rate')
  $startEl.raty({
    size: 36,
    starOff: "/assets/star-off.png",
    starOn: "/assets/star-on.png",
    starHalf: "/assets/star-half.png",
    half: true,
    readOnly: true,
    score: $startEl.data('score')
  });
});
