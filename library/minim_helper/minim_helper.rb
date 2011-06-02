class MinimHelper  
  FREQS = [60, 170, 310, 600, 1000, 3000, 6000, 12000, 14000, 16000]
  MAX_AMP_FLOOR = 0.80
  
  attr_accessor :fft_smooth
  attr_reader :fft_amps, :scaled_amps, :max_amp, :min_amp
  
  def initialize(minim, fft)
    @minim = minim
    @input = @minim.get_line_in
    @fft = fft.new(@input.left.size, 44100)
    @fft_amps = [0.01]*FREQS.size
    @prev_fft_amps = [0.01]*FREQS.size
    @max_amps = [MAX_AMP_FLOOR]*FREQS.size
    @scaled_amps = [0.01]*FREQS.size
    @fft_smooth = 0.5
  end
  
  def update
    @prev_fft_amps = @fft_amps
    @fft.forward @input.left
    
    FREQS.each_with_index do |freq, i|
      amp = @fft.get_freq(freq)
      
      @fft_amps[i] = (1-@fft_smooth)*amp + (@fft_smooth)*@prev_fft_amps[i]

      @max_amp = @fft_amps[i] if !@max_amp || @fft_amps[i] > @max_amp
      @min_amp = @fft_amps[i] if !@min_amp || @fft_amps[i] < @min_amp

      @scaled_amps[i] = (@fft_amps[i] - @min_amp) / (@max_amp - @min_amp)
      
      @scaled_amps[i] = 0 if @scaled_amps[i] < 1e-44

      @max_amp *= 0.9999
      @min_amp *= 0.9999
    end
  end
  
end