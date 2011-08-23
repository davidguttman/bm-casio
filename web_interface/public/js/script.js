(function() {
  var Blanket;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Blanket = (function() {
    function Blanket(opts) {
      this.opts = opts;
      this.refresh_status();
      this.trackers_target = $('#trackers');
    }
    Blanket.prototype.refresh_status = function() {
      return $.getJSON('/status', __bind(function(data) {
        this.trackers = data;
        return this.create_ui();
      }, this));
    };
    Blanket.prototype.slider = function(opts) {
      var label, slider, slider_container, value;
      slider_container = $("<div class='slider_container'></slider>");
      label = $("<h4>" + opts.name + ":</h4>");
      value = $("<input type='text' value='" + opts.value + "'/>");
      slider = $("<div id='slider_" + opts.tracker_i + "_" + name + "' class='slider'></div>").slider({
        min: opts.min,
        max: opts.max,
        value: opts.value,
        step: (opts.max - opts.min) / 1000,
        change: function(event, ui) {
          console.log(ui);
          return $.get("/set/" + opts.tracker_i + "/" + opts.name + "?value=" + ui.value, function() {
            return value.val(ui.value);
          });
        }
      });
      return slider_container.append(label, value, slider);
    };
    Blanket.prototype.create_ui = function() {
      this.trackers_target.html();
      return _.each(this.trackers, __bind(function(tracker, i) {
        var tracker_target;
        tracker_target = $("<div id='tracker_" + i + "'><h1>Tracker " + i + "</h1></div>");
        this.trackers_target.append(tracker_target);
        console.log("Tracker " + i + ": ");
        return _.each(tracker, __bind(function(properties, name) {
          console.log(properties);
          properties.tracker_i = i;
          return tracker_target.append(this.slider(properties));
        }, this));
      }, this));
    };
    return Blanket;
  })();
  $(document).ready(function() {
    var b;
    return b = new Blanket();
  });
}).call(this);
