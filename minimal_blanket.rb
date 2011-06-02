# Minimal Blanket

require 'rubygems'
Gem.clear_paths
ENV['GEM_HOME'] = '/Users/dguttman/.rvm/gems/jruby-1.6.1'
ENV['GEM_PATH'] = '/Users/dguttman/.rvm/gems/jruby-1.6.1:/Users/dguttman/.rvm/gems/jruby-1.6.1@global'

class MinimalBlanket < Processing::App

  load_libraries :trig

  include Trig

  def setup
    @osc = OSCHelper.new
  end
  
  def draw
    if frame_count % 60 == 0
      @osc.send('/hello', "sup")
    end
  end
  
end

class OSCHelper
  require 'osc-ruby'
  require 'osc-ruby/em_server'
  include OSC
  
  attr_reader :server, :client
  
  def initialize(opts={})
    puts "Starting OSC server and client ..."
    @server = EMServer.new 9090
    @client = Client.new 'localhost', 9090
    
    Thread.new do
      @server.run
    end
    
    set_patterns
  end
  
  def send(address, message)
    m = Message.new(address, message)
    @client.send(m)
  end
  
  def set_patterns
    @server.add_method '/hello' do |message|
      p message
    end
  end
  
end

MinimalBlanket.new :title => "Minimal Blanket"