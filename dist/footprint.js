$(function() {
  var $postButtom, onAjaxSuccess, postAjax;
  $postButtom = $('.postButton');
  onAjaxSuccess = function(data) {};
  postAjax = function() {
    return $.post('/save', {
      elementName: "oen",
      userAction: "two",
      widget: "three",
      role: "Employee"
    }, onAjaxSuccess);
  };
  return $postButtom.click(function() {
    return postAjax();
  });
});
