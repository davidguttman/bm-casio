class Blanket
  constructor: (@opts) ->
    @refresh_status()
    @trackers_target = $('#trackers')
  
  refresh_status: ->
    $.getJSON '/status', (data) =>
      @trackers = data
      @create_ui()
  
  slider: (opts) ->
    slider_container = $("<div class='slider_container'></slider>")
    label = $("<h4>#{opts.name}:</h4>")
    value = $("<input type='text' value='#{opts.value}'/>")
    slider = $("<div id='slider_#{opts.tracker_i}_#{name}' class='slider'></div>").slider
      min: opts.min
      max: opts.max
      value: opts.value
      step: (opts.max - opts.min)/1000 
      change: (event, ui) ->
        console.log ui
        $.get "/set/#{opts.tracker_i}/#{opts.name}?value=#{ui.value}", ->
          value.val(ui.value)
        
    slider_container.append(label, value, slider)
  
  create_ui: ->
    @trackers_target.html()
    
    _.each @trackers, (tracker, i) =>
      tracker_target = $("<div id='tracker_#{i}'><h1>Tracker #{i}</h1></div>")
      @trackers_target.append(tracker_target)
      
      console.log "Tracker #{i}: "
      
      _.each tracker, (properties, name) =>
        console.log properties
        properties.tracker_i = i
        tracker_target.append(@slider(properties))

$(document).ready ->
  b = new Blanket()