class MinimHelper  
  FREQS = [60, 170, 310, 600, 1000, 3000, 6000, 12000, 14000, 16000]
  MAX_AMP_FLOOR = 0.80
  
  attr_reader :raw_amps, :max_amp, :min_amp
  
  def initialize(minim, fft)
    @n_prevs = 60
    @minim = minim
    @input = @minim.get_line_in
    @fft = fft.new(@input.left.size, 44100)
    @raw_amps = [0.01]*FREQS.size
    @fft_amps = [0.01]*FREQS.size
    @prev_amps = []
    @max_amps = [MAX_AMP_FLOOR]*FREQS.size
    @scaled_amps = [0.01]*FREQS.size
    @smooth_amps = {}
  end
  
  # make the scaled/smooth functions
  
  def update
    @prev_amps.unshift @raw_amps
    @prev_amps = @prev_amps[0...@n_prevs] if @prev_amps.size > @n_prevs
    
    @fft.forward @input.left
    
    FREQS.each_with_index do |freq, i|
      amp = @fft.get_freq(freq)
      @raw_amps[i] = amp

      @max_amp = amp if !@max_amp || amp > @max_amp
      @min_amp = amp if !@min_amp || amp < @min_amp

      @max_amp *= 0.9999
      @min_amp *= 0.9999
    end
  end
  
  def smooth_amps(smooth_factor)
    @smooth_amps[smooth_factor] ||= scaled_amps
    previous_smooth = @smooth_amps[smooth_factor]
    new_smooth = []
    scaled_amps.each_with_index do |amp, i|
      smooth_amp = (1-smooth_factor)*amp + (smooth_factor)*previous_smooth[i]
      new_smooth << smooth_amp
    end
    @smooth_amps[smooth_factor] = new_smooth
  end
  
  def scaled_amps
    scaled_amps = []
    @raw_amps.each do |amp| 
      scaled_amp = (amp - @min_amp) / (@max_amp - @min_amp)
  
      scaled_amp = 0 if scaled_amp < 1e-44 || scaled_amp.nan?
      scaled_amps << scaled_amp
    end
    scaled_amps
  end
end