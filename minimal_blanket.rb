# Minimal Blanket

class MinimalBlanket < Processing::App

  load_libraries :trig, :osc_helper

  include Trig

  def setup
    @osc = OSCHelper.new do |message|
      osc(message)
    end
  end
  
  def draw

  end
  
  def osc(message)
    address, args = message.address, message.to_a
  end
  
end



MinimalBlanket.new :title => "Minimal Blanket"