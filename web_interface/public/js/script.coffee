class Blanket
  constructor: (@opts) ->
    @refresh_status()
    @trackers_target = $('#trackers')
  
  refresh_status: ->
    $.getJSON '/status', (data) =>
      @trackers = data
      @create_ui()
  
  create_ui: ->
    @trackers_target.html()
    
    _.each @trackers, (tracker, i) =>
      tracker_target = $("<div id='tracker_#{i}'><h1>Tracker #{i}</h1></div>")
      @trackers_target.append(tracker_target)
      
      console.log "Tracker #{i}: "
      
      _.each tracker, (properties, name) =>
        console.log properties
        tracker_target.append("<h4>#{name}:</h4>")
        slider = $("<div id='slider_#{i}_#{name}'></div>").slider
          min: properties.min
          max: properties.max
          value: properties.value
          step: (properties.max - properties.min)/1000 
          change: (event, ui) ->
            console.log ui
        tracker_target.append(slider)

$(document).ready ->
  b = new Blanket()