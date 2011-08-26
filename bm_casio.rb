# Minimal Blanket

class BMCasio < Processing::App

  load_libraries :trig, :osc_helper, :minim, :minim_helper, :stalagmite, :settings_tracker
  import 'ddf.minim'
  import 'ddf.minim.analysis'

  include Trig

  def setup
    render_mode JAVA2D
    color_mode HSB
    rect_mode CENTER

    smooth
    background 0
    @osc = setup_osc
    @sound = setup_sound
    @trackers = [create_settings_tracker]
    # @stalagmites = @trackers.map {|tracker| Stalagmite.new(tracker, :y => height/2) }
  end
  
  def draw
    clear 255
    @sound.update
    samps = @sound.smooth_amps(0.96)

    samps = samps[1..-1]

    avg_samps = avg_samples(samps, 4)    
    @maxima = maxima_score(avg_samps, 0.7)
    
    draw_samples(samps)
  end
  
  def maxima_score(samps, avg)
    maxima = count_local_maxima(samps)
    
    @maxima_max ||= maxima
    @maxima_max = maxima if maxima > @maxima_max
    
    @maxima_min ||= maxima
    @maxima_min = maxima if maxima < @maxima_min

    maxima_diff = @maxima_max - @maxima_min
    
    if maxima_diff > 0
      maxima_rel = (maxima.to_f - @maxima_min)/maxima_diff
    else
      maxima_rel = 0
    end
    
    @last_maxima ||= maxima_rel
    
    maxima_rel = (maxima_rel * (1-avg)) + (@last_maxima * avg)
    @last_maxima = maxima_rel
    
    @maxima_min = 0.9999*@maxima_min + 0.0001*@maxima_max
    @maxima_max = 0.9999*@maxima_max + 0.0001*@maxima_min
    
    return maxima_rel
  end
  
  def draw_samples(samples)

    n = samples.size.to_f
    w = (width/n)/2.floor

    # hue_shift = (frame_count/60.0)
    hue_shift = 0

    begin_shape
    curve_vertex width/2, height/2
    curve_vertex width/2, height/2

    unwind = []

    samples.each_with_index do |samp, i|
      samp = log(samp*100+1)/log(101)
      # samp = log(samp*100+1)/log(101) 

      h = ((@maxima * 255) + hue_shift) % 255
      s = 100
      b = (samp * 255 + 100)
      
      fill h, s, b, 255
      # no_fill
      # stroke_weight 2
      # stroke h, s, b
      
      x1 = (width/2)+(i*w)
      x2 = (width/2)-(i*w)
      x3 = (width/2)+(i*w)
      x4 = (width/2)-(i*w)
      
      lh = samp*height
      y = height/2 + lh/2
      
      curve_vertex x1, y
      unwind << [x1, y-lh]
      # rect x1, y+lh/2, 2, 2
      
      # rect x1, y, w, -lh
      # rect x2, y, -w, -lh
      # 
      # tip_length = 8
      # fill h, 0, 0
      # rect x1, y-(tip_length/2), w, -(lh-tip_length)
      # rect x2, y-(tip_length/2), -w, -(lh-tip_length)
           
      # rect x3, height/2, w, samp*height/2
      # rect x4, height/2, -w, samp*height/2
    end
    
    unwind.reverse.each do |x, y|
      curve_vertex x, y
    end
    
    curve_vertex width/2, height/2
    curve_vertex width/2, height/2
    end_shape
  end
  
  def count_local_maxima(samples)
    n_maxima = 0
    samples.each_with_index do |samp, i|
      next if i == 0 or i == samples.size-1
      if samp > samples[i-1] and samp > samples[i+1]
        n_maxima += 1
      end
    end
    return n_maxima
  end
  
  def avg_samples(samps, n_avg)
    avg_samps = []
    
    samps.each_with_index do |samp, i|
      next if i < n_avg/2 or i > ((samps.size-1)-(n_avg/2))

      to_avg = []
      
      (1..(n_avg/2)).each do |n|
        to_avg << samps[i-n]
        to_avg << samps[i+n]
      end
      
      to_avg << samp
      
      sum = to_avg.inject(0) {|memo, val| memo + val}

      avg_samps << sum/to_avg.size
    end
    avg_samps
  end
  
  def clear(opacity=255)
    no_stroke
    fill 0, 0, 0, opacity
    rect width/2, height/2, width, height
  end
  
  def create_settings_tracker
    st = SettingsTracker.new
    st.slider 'size', 400, 1..1000, 'shape'
    st.slider 'fft_smooth', 0.50, 0..1.0, 'sound'

    st.slider 'fill_red', 255, 0..255, 'color'
    st.slider 'fill_green', 255, 0..255, 'color'
    st.slider 'fill_blue', 255, 0..255, 'color'
    st.slider 'sound_fill_red', 255, 0..255, 'color'
    st.slider 'sound_fill_green', 255, 0..255, 'color'
    st.slider 'sound_fill_blue', 255, 0..255, 'color'
    
    st.slider 'fill_opacity', 100, 0..255, 'color'

    st.slider 'stroke_weight', 1, 0..20, 'shape'
    st.slider 'stroke_offset', -50, -200..200, 'color'
    st.slider 'stroke_opacity', 100, 0..255, 'color'
    return st
  end
  
  def save_state(filename="last_state.json")
    file = File.new(filename, 'w')
    file << tracker_state
    file.close
  end
  
  def restore_state(filename="last_state.json")
    return unless File.exists? filename
    state = JSON.parse(File.read(filename))
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
  
  def osc_save_state(args)
    filename = args.first
    save_state(filename)
  end
  
  def osc_restore_state(args)
    filename = args.first
    restore_state(filename)
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

BMCasio.new :title => "BM Casio", :width => 960, :height => 768, :full_screen => fullscreen