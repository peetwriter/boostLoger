drawAnnotations = (userUri, roleUri)->
  $.get "/api/allClicks/#{userUri}/#{roleUri}", (data) ->
    secondData = _.map data, (item) ->
      date = moment item.createdAt
      startOftheDay = date.startOf('day')
      time: moment(item.createdAt).diff startOftheDay, "minutes"
      widget: item.widget
      date: item.date
    groupedData = _.groupBy secondData, (item) -> item.date
    hourData = new google.visualization.DataTable
    hourData.addColumn 'date', 'date'
    hourData.addColumn 'number', 'Welcome'
    hourData.addColumn 'number', 'Access'
    hourData.addColumn 'number', 'Employee'
    hourData.addColumn 'number', 'BCN'
    hourData.addColumn 'number', 'Resources'
    hourData.addColumn 'number', 'Graph'
    hourData.addColumn 'number', 'Search'
    finalData = []
    _.each groupedData, (groupedItem, key) ->
      _.each groupedItem, (item) ->
        retArray = [moment(key).toDate(), 0, 0, 0, 0, 0, 0, 0]
        if item.widget == "Welcome"
          retArray[1] = item.time
        if item.widget == "Access"
          retArray[2] = item.time
        if item.widget == "Employee"
          retArray[3] = item.time
        if item.widget == "BCN"
          retArray[4] = item.time
        if item.widget == "Resources"
          retArray[5] = item.time
        if item.widget == "Graph"
          retArray[6] = item.time
        if item.widget == "Search"
          retArray[7] = item.time
        finalData.push retArray
    hourOptions =
      chart:
        title: 'User clisks in widget by date'
        subtitle: 'based on cliks by minute'
      height: 400
      pointSize: 30
      axes: y:
        'Cicks': label: 'in each widget'
      chartArea:
        width: "80%"
        height: "80%"
      vAxis:
        minValue:0
        format:'##h'
    hourData.addRows finalData
    hchart = new google.charts.Scatter(document.getElementById('scatter_dual_y'))
    selectHandler = (e) ->
      unless _.isEmpty hchart.getSelection()
        selectedDate = moment(hourData.Lf[hchart.getSelection()[0].row].c[0].v)
        finalData = []
        _.each data, (item) ->
          if moment(item.createdAt).format("L") is selectedDate.format("L")
            finalData.push {
              date: item.createdAt
              widget: item.widget
            }
        _.sortBy finalData, (n) ->
          moment(n.date)

        finalOrderedData = []
        previousWidget = finalData[0].widget
        acc = 0
        accStart= 1000
        accEnd= 1000
        _.each finalData, (item, key) ->
          accEnd += 1000
          if item.widget != previousWidget or key+1 is finalData.length
            finalOrderedData.push [previousWidget, accStart, accEnd]
            accStart = accEnd
          previousWidget = item.widget

        container = document.getElementById('timeline')
        timlelineChart = new google.visualization.Timeline container
        timeLineData = new google.visualization.DataTable
        timeLineData.addColumn
          type: 'string'
          id: 'Widget'
        timeLineData.addColumn
          type: 'number'
          id: 'Start'
        timeLineData.addColumn
          type: 'number'
          id: 'End'
        timeLineData.addRows finalOrderedData
        timlelineChart.draw timeLineData

    google.visualization.events.addListener hchart, 'select', selectHandler
    unless _.isEmpty data
      hchart.draw hourData, hourOptions


  # ==================================================
  # Bar Charts
  # ==================================================
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

      hourData = new google.visualization.DataTable
      hourData.addColumn 'date', 'date'
      hourData.addColumn 'number', 'Welcome'
      hourData.addColumn 'number', 'Access'
      hourData.addColumn 'number', 'Employee'
      hourData.addColumn 'number', 'BCN'
      hourData.addColumn 'number', 'Resources'
      hourData.addColumn 'number', 'Graph'
      hourData.addColumn 'number', 'Search'
      hourData.addRows([
          [moment().toDate(), 0, 1, 2, 3, 4, 5, 6], [moment().add(1,"days").toDate(),1,0,0,0,0,0,0.5]
        ])

      wdata = google.visualization.arrayToDataTable finalwidgetData
      pdata = google.visualization.arrayToDataTable finalPhaseData
      options =
        height: 400
        legend:
          position: 'top'
          maxLines: 3
        bar: groupWidth: '75%'
        isStacked: true
        chartArea:
          width: "80%"
          height: "80%"
      pchart = new (google.visualization.ColumnChart)(document.getElementById('phaseData'))
      wchart = new (google.visualization.ColumnChart)(document.getElementById('widgetData'))
      pchart.draw pdata, options
      wchart.draw wdata, options

google.load 'visualization', '1',
  packages: [ 'corechart', 'bar', 'scatter', 'timeline' ]
  callback: drawAnnotations
