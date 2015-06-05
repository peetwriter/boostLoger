$ ->
  $postButtom = $('.postButton')
  onAjaxSuccess = (data) ->
    return

  postAjax = ->
    $.post '/save', {
        elementName: "oen"
        userAction: "two"
        widget: "three"
        role: "Employee"
      }, onAjaxSuccess

myFunction = (userUri, roleUri)->
  $.get "/api/#{userUri}/#{roleUri}", (data) ->
    console.log data
