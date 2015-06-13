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

fillEmptyDataWithDayDates = (data) ->
  if _.isEmpty data then return []
  fullDatesArray = [
      date: moment(_.first(data).date).format "YYYY-MM-DD"
      count: 0
  ]
  endDate = moment().subtract(1, "days")
  while  moment(_.last(fullDatesArray).date) < endDate
      fullDatesArray.push
          date: moment(_.last(fullDatesArray).date).add(1, "days").format "YYYY-MM-DD"
          count: 0
  _.each data, (item) ->
      if sameItem = (_.findWhere fullDatesArray, {"date": moment(item.date).format "YYYY-MM-DD" })
          sameItem.count = item.count
  fullDatesArray

drawGraph = (userUri, roleUri)->
  $.get "/api/#{userUri}/#{roleUri}", (data) ->
    data = fillEmptyDataWithDayDates data
    labels = _.map data, (item) -> item.date

    graphData =
      labels: labels
      datasets: [
        {
          label: 'My First dataset'
          fillColor: 'rgba(220,220,220,0.2)'
          strokeColor: 'rgba(220,220,220,1)'
          pointColor: 'rgba(220,220,220,1)'
          pointStrokeColor: '#fff'
          pointHighlightFill: '#fff'
          pointHighlightStroke: 'rgba(220,220,220,1)'
          data: _.map data, (item) -> item.count
        }
      ]
    options =
      scaleShowGridLines: true
      scaleGridLineColor: 'rgba(0,0,0,.05)'
      scaleGridLineWidth: 1
      scaleShowHorizontalLines: true
      scaleShowVerticalLines: true
      bezierCurve: true
      bezierCurveTension: 0.4
      pointDot: true
      pointDotRadius: 4
      pointDotStrokeWidth: 1
      pointHitDetectionRadius: 20
      datasetStroke: true
      datasetStrokeWidth: 2
      datasetFill: true
      legendTemplate: '<ul class="<%=name.toLowerCase()%>-legend"><% for (var i=0; i<datasets.length; i++){%><li><span style="background-color:<%=datasets[i].strokeColor%>"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>'
    ctx = document.getElementById("myChart").getContext "2d"
    myNewChart = new Chart(ctx).Line(graphData, options)
