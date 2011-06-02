class Stalagmite
  include Processing::Proxy
  include Trig
  
  def initialize(settings_tracker, opts={})
    @st = settings_tracker
    @x = opts[:x] || 0
    @y = opts[:y] || 0
  end
  
  def update
    @vel = 1
    @dir = TWO_PI/360.0
    
    x, y = cartesian(@vel, @dir)
    @x += x
    @y += y
  end
  
  def draw
    fr = 255
    fg = 255
    fb = 255
    fa = 255

    sr = 200
    sg = 200
    sb = 200
    sa = 100
    sw = 2

    dw = @st['size']
    dh = 20

    fill fr, fg, fb, fa
    stroke sr, sg, sb, sa

    ellipse @x, @y, dw, dh
  end
  
  
end