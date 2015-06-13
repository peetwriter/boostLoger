drawAnnotations = (userUri, roleUri)->
  $.get "/api/phases/#{userUri}/#{roleUri}", (data) ->
    widgetData = []
    phaseData = []
    unless _.isEmpty data
      _.each data, (item) ->
        widgetRes = [item.date]
        phaseRes = [item.date]
        widgetRes.push item.item.Welcome or 0
        widgetRes.push item.item.Access or 0
        widgetRes.push item.item.Employee or 0
        widgetRes.push item.item.BCN or 0
        widgetRes.push item.item.Resources or 0
        widgetRes.push item.item.Graph or 0
        widgetRes.push item.item.Search or 0

        phaseRes.push (item.item.Welcome or 0) + (item.item.Access or 0) + 0
        phaseRes.push (item.item.Employee or 0) + (item.item.BCN or 0) + (item.item.Graph) or 0 + 0
        phaseRes.push (item.item.Resources or 0) + (item.item.Search or 0) or 0 + 0

        phaseData.push phaseRes
        widgetData.push widgetRes

      finalwidgetData =  [[
        ""
        'Welcome'
        'Access'
        'Employee'
        'BCN'
        'Resources'
        'Graph'
        'Search'
      ]].concat widgetData

      finalPhaseData =  [[
        ""
        'Start'
        'Management'
        'Learning'
      ]].concat phaseData

      wdata = google.visualization.arrayToDataTable finalwidgetData
      pdata = google.visualization.arrayToDataTable finalPhaseData
      options =
        height: 400
        legend:
          position: 'top'
          maxLines: 3
        bar: groupWidth: '75%'
        isStacked: true
      pchart = new (google.visualization.ColumnChart)(document.getElementById('phaseData'))
      wchart = new (google.visualization.ColumnChart)(document.getElementById('widgetData'))
      pchart.draw pdata, options
      wchart.draw wdata, options

google.load 'visualization', '1',
  packages: [ 'corechart', 'bar' ]
  callback: drawAnnotations
