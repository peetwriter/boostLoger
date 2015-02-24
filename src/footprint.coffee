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

  $postButtom.click -> postAjax()
