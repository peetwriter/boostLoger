var myFunction;

$(function() {
  var $postButtom, onAjaxSuccess, postAjax;
  $postButtom = $('.postButton');
  onAjaxSuccess = function(data) {};
  return postAjax = function() {
    return $.post('/save', {
      elementName: "oen",
      userAction: "two",
      widget: "three",
      role: "Employee"
    }, onAjaxSuccess);
  };
});

myFunction = function(userUri, roleUri) {
  return $.get("/api/" + userUri + "/" + roleUri, function(data) {
    return console.log(data);
  });
};
