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
    Blanket.prototype.create_ui = function() {
      this.trackers_target.html();
      return _.each(this.trackers, __bind(function(tracker, i) {
        var tracker_target;
        tracker_target = $("<div id='tracker_" + i + "'><h1>Tracker " + i + "</h1></div>");
        this.trackers_target.append(tracker_target);
        console.log("Tracker " + i + ": ");
        return _.each(tracker, __bind(function(properties, name) {
          var slider;
          console.log(properties);
          tracker_target.append("<h4>" + name + ":</h4>");
          slider = $("<div id='slider_" + i + "_" + name + "' class='slider'></div>").slider({
            min: properties.min,
            max: properties.max,
            value: properties.value,
            step: (properties.max - properties.min) / 1000,
            change: function(event, ui) {
              console.log(ui);
              return $.get("/set/" + i + "/" + name + "?value=" + ui.value);
            }
          });
          return tracker_target.append(slider);
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
