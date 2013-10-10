# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  setTimeout "scrollTo(0,1)", 100

  $("div#bookmarkGrid div").hover ( ->
    $(this).find(".panelFooter").css { display: "inline" }
    $(this).find(".panelFooter").animate {height: "52px"}, 400
    ), ->
    $(this).find(".panelFooter").animate {height: "0"}, 400

  $("input#bookmark_url").on "keypress, keydown, keyup, focus, blur", ->
    isUrl = $(this).val().match(/http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+/)

    if isUrl
      $(".inputUrl p input[type='submit']").css { "background-color": "#e74c3c" }
    else
      $(".inputUrl p input[type='submit']").css { "background-color": "#fb8a78" }

  $('#bookmarkGrid').masonry
    columnWidth: 300
    itemSelector: '#bookmarkGrid>div'