# Minimal Blanket

require 'rubygems'
Gem.clear_paths
ENV['GEM_HOME'] = '/Users/dguttman/.rvm/gems/jruby-1.6.1'
ENV['GEM_PATH'] = '/Users/dguttman/.rvm/gems/jruby-1.6.1:/Users/dguttman/.rvm/gems/jruby-1.6.1@global'

class MinimalBlanket < Processing::App
  

  load_libraries :trig

  def setup
    p polar(200, 4302)
  end
  
  def draw
  
  end
  
end

MinimalBlanket.new :title => "Minimal Blanket"