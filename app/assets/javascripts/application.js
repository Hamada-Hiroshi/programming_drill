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
//= require jquery
//= require jquery-ui
//= require tag-it
//= require chartkick
//= require Chart.bundle
//= require marked
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .


//画像アップロード時のプレビュー表示
$(document).on('turbolinks:load', function(){
  $('#image').on('change', function (e) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $("#imagePreview").attr('src', e.target.result);
    }
    reader.readAsDataURL(e.target.files[0]);
  });
});


//トップページのアニメーション
$(document).on('turbolinks:load', function(){
  $('#top-message h1').hide();
  $('#top-message h1').fadeIn(2500);
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
  $('textarea').on('click input paste cut', function(){
    if ($(this).outerHeight() > this.scrollHeight){
      $(this).height(1)
    }
    while ($(this).outerHeight() < this.scrollHeight){
      $(this).height($(this).height() + 1)
    }
  });
});


//フラッシュメッセージの表示、(一定時間で非表示)
$(document).on('turbolinks:load', function(){
  $('.header-flash').hide();
  $('.header-flash').slideDown();
  /*
  $(function(){
    setTimeout("$('.header-flash').slideUp('slow')", 4000);
  });
  */
});


//言語別・タグ別検索バーのcurrent表示
$(document).on('turbolinks:load', function(){
  var url = window.location.pathname;
  var lang_url = "/"+url.split("/")[1]+"/"+url.split("/")[2];
  $('a[href="'+lang_url+'"] .current-lang').addClass('lang-active');

  var params = window.location.search
  var tag_url = "/apps/tag"+params;
  var rate_tag_url = "/apps/rate_tag"+params;
  var popular_tag_url = "/apps/popular_tag"+params;
  $('.current-tag a[href="'+tag_url+'"]').addClass('tag-active');
  $('.current-tag a[href="'+rate_tag_url+'"]').addClass('tag-active');
  $('.current-tag a[href="'+popular_tag_url+'"]').addClass('tag-active');
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
      if (scrollTop > sidebar_top - 100){
        // 現在位置が、初期位置より下なら、画面上部にサイドバーを固定
        sidebar.css({
          'position': 'fixed',
          'top': 100,
          'width': sidebar.width()
        });
      }
    });
  }
});


//タグ付け、自動補完
$(document).on('turbolinks:load', function(){
  if($('#app-tags').length){
    $('#app-tags').html('');
    $('#app-tags').tagit({
      fieldName: 'app[tag_list]',
      singleField: true,
      availableTags: gon.available_tags
    });
    var i, len, tag;
    if (gon.app_tags != null) {
      for (i = 0, len = gon.app_tags.length; i < len; i++) {
        tag = gon.app_tags[i];
        $('#app-tags').tagit('createTag', tag);
      }
    }
  }
});


//マークダウン記法
$(document).on('turbolinks:load', function(){
  if($("#marked-text").length){
    var text = $("#marked-text").html();
    $("#marked-text").html(marked(text));
  }
});

$(document).on('turbolinks:load', function(){
  if($("#marked-area").length){
    var html = $("#editor textarea").val();
    $("#marked-area").html(marked(html));

    $(function() {
      $("#editor textarea").each(function () {
        $(this).on('keyup', replaceMarkdown(this));
      });

      function replaceMarkdown(elm) {
        var v, old = elm.value;
        return function () {
          if (old != (v = elm.value)) {
          old = v;
          str = $(this).val();
          $("#marked-area").html(marked(str));
          }
        }
      }
    });
  }
});

