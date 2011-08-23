class Stalagmite
  include Processing::Proxy
  include Trig
  
  def initialize(settings_tracker, opts={})
    @st = settings_tracker
    @x = opts[:x] || 0
    @y = opts[:y] || 0
  end
  
  def update(sound)
    @amps = sound.smooth_amps(@st['fft_smooth'])

    @vel = 1
    @dir = TWO_PI/360.0
    
    x, y = cartesian(@vel, @dir)
    @x += x
    @y += y
    
    @x = @x % width
    @y = @y % height
  end
  
  def draw
    fr = @st['fill_red'] + (@amps[2] * @st["sound_fill_red"])
    fg = @st['fill_green'] + (@amps[3] * @st["sound_fill_green"])
    fb = @st['fill_blue'] + (@amps[4] * @st["sound_fill_blue"])
    fa = @st['fill_opacity']

    sr = fr + @st['stroke_offset']
    sg = fg + @st['stroke_offset']
    sb = fb + @st['stroke_offset']
    sa = @st['stroke_opacity']
    
    sw = @st['stroke_weight']

    dr = (@st['size'] * @amps[3]).to_i

    fill fr, fg, fb, fa.to_i
    stroke sr, sg, sb, sa.to_i
    stroke_weight sw
    
    ellipse @x, @y, dr, dr
  end
  
  
end