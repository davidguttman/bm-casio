module Trig
  include Math

  def polar(x,y)
    return Math.hypot(y,x), Math.atan2(y,x)
  end

  def cartesian(r, theta)
    return r*Math.cos(theta), r*Math.sin(theta)
  end
end