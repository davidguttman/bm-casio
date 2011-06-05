class OSCHelper
  require 'rubygems'
  require 'osc-ruby'
  require 'osc-ruby/em_server'
  include OSC
  
  attr_reader :server, :client
  
  def initialize(opts={}, &response)
    puts "Starting OSC server and client ..."
    server_port = opts[:server_port] || 9090    

    client_host = opts[:client_host] || 'localhost'
    client_port = opts[:client_port] || 9091
    
    @server = EMServer.new server_port
    @client = Client.new client_host, client_port
    
    Thread.new do
      @server.run
    end
    
    @server.add_method /.*/ do |message|
      response.call(message)
    end
  end
  
  def send(address, message)
    m = Message.new(address, message)
    puts "sending message #{message}"
    @client.send(m)
  end
  
  def set_patterns(response)

  end
  
end