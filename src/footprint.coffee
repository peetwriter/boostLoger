$ ->
  $postButtom = $('.postButton')
  onAjaxSuccess = (data) ->
    alert data
    return

  postAjax = -> 
    $.post '/save', {
        elementName: "oen"
        userAction: "two"
        widget: "three"
      }, onAjaxSuccess

  $postButtom.click -> postAjax()
