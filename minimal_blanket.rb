# Minimal Blanket

class MinimalBlanket < Processing::App

  load_libraries :trig, :osc_helper

  include Trig

  def setup
    render_mode JAVA2D
    @osc = setup_osc
  end
  
  def draw

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