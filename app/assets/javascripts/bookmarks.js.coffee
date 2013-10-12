# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



$ ->

  setTimeout "scrollTo(0,1)", 100

  panelHover = ->
    $("#bookmarkGrid .panel").hover ( ->
      $(this).find(".panelFooter").css { display: "inline" }
      $(this).find(".panelFooter").animate {height: "52px"}, 400
      ), ->
      $(this).find(".panelFooter").animate {height: "0"}, 400

  panelHover()

  $("input#bookmark_url").on "keyup", ->
    isUrl = $(this).val().match(/http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+/)

    if isUrl
      $(".inputUrl p input[type='submit']").css { "background-color": "#e74c3c" }
    else
      $(".inputUrl p input[type='submit']").css { "background-color": "#fb8a78" }

  $(".inputUrl").on 'ajax:complete', (event,ajax,status) ->
    res = $.parseJSON(ajax.responseText)
    status = res.status
    html = res.html

    if status=="already exist"
      alert status
    else
      $('#bookmarkGrid').prepend(html)
      $('#bookmarkGrid .panel:first-child')
        .height('0')
        .animate
          height: '140px',
          duration: 400
      panelHover()

      $(".deleteButton").on 'ajax:complete', (event,ajax,status) ->
        res = $.parseJSON(ajax.responseText)
        status = res.status

        $thisPanel = $(this).parent().parent().parent()
        $thisPanel.animate
          opacity: '0.0'
          height: '0'
        ,
          duration: 400
          complete: ->
            $(this).remove()


      $("#bookmark_url").val("")

  $(".deleteButton").on 'ajax:complete', (event,ajax,status) ->
    res = $.parseJSON(ajax.responseText)
    status = res.status

    $thisPanel = $(this).parents('.panel')
    $thisPanel.animate
      opacity: '0.0'
      height: '0'
    ,
      duration: 600
      complete: ->
        $(this).remove()



