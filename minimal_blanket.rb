# Minimal Blanket

class MinimalBlanket < Processing::App

  load_libraries :trig, :osc_helper, :minim, :minim_helper
  import 'ddf.minim'
  import 'ddf.minim.analysis'

  include Trig

  def setup
    render_mode JAVA2D
    @osc = setup_osc
    @minim = Minim.new(self)
    @sound = MinimHelper.new(@minim, FFT)
  end
  
  def draw
    @sound.update
    p @sound.scaled_amps
  end
  
  def setup_osc
    osc_helper = OSCHelper.new do |message|
      osc(message)
    end
    return osc_helper
  end
  
  def osc(message)
    address, args = message.address, message.to_a
  end
  
end


fullscreen = true if ARGV[0] == "full"

MinimalBlanket.new :title => "Minimal Blanket", :width => 1280, :height => 768, :full_screen => fullscreen