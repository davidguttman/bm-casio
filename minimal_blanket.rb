# Minimal Blanket

class MinimalBlanket < Processing::App

  load_libraries :trig, :osc_helper, :minim, :minim_helper, :stalagmite, :settings_tracker
  import 'ddf.minim'
  import 'ddf.minim.analysis'

  include Trig

  def setup
    render_mode JAVA2D
    smooth
    background 0
    @osc = setup_osc
    @sound = setup_sound
    @trackers = [create_settings_tracker]
    @stalagmites = @trackers.map {|tracker| Stalagmite.new(tracker, :y => height/2) }
  end
  
  def draw
    @sound.update
    @stalagmites.each do |stalagmite|
      stalagmite.update(@sound)
      stalagmite.draw
    end
  end
  
  def create_settings_tracker
    st = SettingsTracker.new
    st.slider 'size', 400, 1..1000, 'shape'
    st.slider 'fft_smooth', 0.50, 0..1.0, 'sound'
    st.slider 'stroke_weight', 5, 0..20, 'shape'
    return st
  end
  
  def setup_sound
    minim = Minim.new(self)
    sound = MinimHelper.new(minim, FFT)
  end
  
  def setup_osc
    osc_helper = OSCHelper.new do |message|
      osc(message)
    end
    return osc_helper
  end
  
  def tracker_state
    @trackers.map {|tracker| tracker.to_h}.to_json
  end
  
  def osc_status(args)
    puts "args #{args}"
    resp_port = args.first
    ts = tracker_state
    @osc.send('/status', ts)
  end
  
  def osc_set(args)
    t_index, name, value = args[0].to_i, args[1], args[2]
    p "osc set: #{t_index.class}, #{name.class}, #{value.class}"
    @trackers[t_index][name] = value
  end
  
  def osc(message)
    puts "Received message: #{message}"
    address, args = message.address, message.to_a
    method_name = ("osc_" + address.gsub("/", "")).to_sym
    
    if self.respond_to? method_name
      puts "OSC - Calling #{method_name}: #{args.join(", ")}"
      self.send method_name, args
    else
      puts "OSC - No matching address: #{address}"
    end
  end
  
end


fullscreen = true if ARGV[0] == "full"

MinimalBlanket.new :title => "Minimal Blanket", :width => 960, :height => 768, :full_screen => fullscreen