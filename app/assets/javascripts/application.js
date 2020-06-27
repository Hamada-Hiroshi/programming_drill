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
//= require bootstrap-sprockets
//= require_tree .

//画像アップロード時のプレビュー表示
$(document).on('turbolinks:load', function(){
  $('#myImage').on('change', function (e) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $("#profilePreview").attr('src', e.target.result);
    }
    reader.readAsDataURL(e.target.files[0]);
  });
});

//レビューの星表示
$(document).on('turbolinks:load', function(){
  $('#star').html('');
  $('#star').raty({
    size: 36,
    starOff: "/star-off.png",
    starOn: "/star-on.png",
    starHalf: "/star-half.png",
    scoreName: 'review[rate]',
    half: true,
  });
});

$(document).on('turbolinks:load', function(){
  var $startEl = $('.star-rate')
  $startEl.html('');
  $startEl.raty({
    size: 36,
    starOff: "/star-off.png",
    starOn: "/star-on.png",
    starHalf: "/star-half.png",
    half: true,
    readOnly: true,
    score: $startEl.data('score')
    //scoreは無くても機能する。（データ属性で'score'をそのまま渡しているため）
  });
});

//テキストエリアの高さ自動調整
$(document).on('turbolinks:load', function(){
  var $obj = $('textarea');
  var height = parseInt($obj.css('lineHeight'));
  $obj.on('click', function(e) {
    var lines = ($(this).val() + '\n').match(/\n/g).length;
    $(this).height(height  * lines);
  });
  $obj.on('input', function(e) {
    var lines = ($(this).val() + '\n').match(/\n/g).length;
    $(this).height(height  * lines);
  });
});

//フラッシュメッセージの表示
$(document).on('turbolinks:load', function(){
  $('.header-flash').hide();
  $('.header-flash').slideDown();
});

//リンクバー固定、current表示
$(document).on('turbolinks:load', function(){
  var url = window.location.pathname;
  $('.current-btn a[href="'+url+'"]').addClass('btn-active');

  var sidebar = $('.link-bar');
  if(sidebar.length){
    // サイドバーの位置
    var sidebar_top = sidebar.offset().top;
    $(window).on('scroll resize', function(){ // スクロールかリサイズ時
      // 現在の位置
      var scrollTop = $(document).scrollTop();
      if (scrollTop > sidebar_top - 80){
        // 現在位置が、初期位置より下なら、画面上部にサイドバーを固定
        sidebar.css({'position': 'fixed',
            'top': 80,
            'width': sidebar.width()
        });
      }
    });
  }
});

//リンク先プレビュー表示
$(document).on('turbolinks:load', function(){
  $('.URL').miniPreview({
    width: 256,
    height: 144,
    scale: .25,
    prefetch: 'pageload'
  });
});

