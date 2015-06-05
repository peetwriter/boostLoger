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
    var ctx, graphData, labels, myNewChart, options;
    console.log(data);
    labels = _.map(data, function(item) {
      return item.date;
    });
    graphData = {
      labels: labels,
      datasets: [
        {
          label: 'My First dataset',
          fillColor: 'rgba(220,220,220,0.2)',
          strokeColor: 'rgba(220,220,220,1)',
          pointColor: 'rgba(220,220,220,1)',
          pointStrokeColor: '#fff',
          pointHighlightFill: '#fff',
          pointHighlightStroke: 'rgba(220,220,220,1)',
          data: _.map(data, function(item) {
            return item.count;
          })
        }
      ]
    };
    options = {
      scaleShowGridLines: true,
      scaleGridLineColor: 'rgba(0,0,0,.05)',
      scaleGridLineWidth: 1,
      scaleShowHorizontalLines: true,
      scaleShowVerticalLines: true,
      bezierCurve: true,
      bezierCurveTension: 0.4,
      pointDot: true,
      pointDotRadius: 4,
      pointDotStrokeWidth: 1,
      pointHitDetectionRadius: 20,
      datasetStroke: true,
      datasetStrokeWidth: 2,
      datasetFill: true,
      legendTemplate: '<ul class="<%=name.toLowerCase()%>-legend"><% for (var i=0; i<datasets.length; i++){%><li><span style="background-color:<%=datasets[i].strokeColor%>"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>'
    };
    ctx = document.getElementById("myChart").getContext("2d");
    return myNewChart = new Chart(ctx).Line(graphData, options);
  });
};
