# Minimal Blanket

class MinimalBlanket < Processing::App

  load_libraries :trig, :osc_helper, :minim, :minim_helper, :stalagmite, :settings_tracker
  import 'ddf.minim'
  import 'ddf.minim.analysis'

  include Trig

  def setup
    render_mode JAVA2D
    background 0
    @osc = setup_osc
    @sound = setup_sound
    @trackers = [create_settings_tracker]
    @stalagmites = @trackers.map {|tracker| Stalagmite.new(tracker) }
  end
  
  def draw
    @sound.update
    @stalagmites.each do |stalagmite|
      stalagmite.update
      stalagmite.draw
    end
  end
  
  def create_settings_tracker
    st = SettingsTracker.new
    st.slider 'size', 10, 1..20, 'shape'
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
  
  def osc(message)
    address, args = message.address, message.to_a
    case address
    when /^\/set\/.+/
      t_index = address.split("/")[2].to_i
      name, value = args[0], args[1]
      @trackers[t_index][name] = value
    else
      puts "OSC - No matching address: #{address}"
    end
  end
  
end


fullscreen = true if ARGV[0] == "full"

MinimalBlanket.new :title => "Minimal Blanket", :width => 1280, :height => 768, :full_screen => fullscreen