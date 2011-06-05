require 'rubygems'
require 'sinatra'
require 'osc-ruby'
require 'json'

def set_tracker(tracker_id, setting_name, value)
  address = "/set"
  m = OSC::Message.new(address, tracker_id, setting_name, value.to_f)
  @@osc_client.send(m)
end

def setup_osc
  @@osc_server = OSC::Server.new(9091)
  @@osc_client = OSC::Client.new('localhost', 9090)

  Thread.new do
    @@osc_server.run
  end

  @@osc_server.add_method '/status' do |message|
    # @@tracker_settings = JSON.parse(message.to_a.first)
    @@tracker_settings = message.to_a.first
  end
end

setup_osc

set :public, File.dirname(__FILE__) + '/public'

get '/' do
  File.read(File.dirname(__FILE__) + '/public/index.html')
end

get '/status' do
  @@tracker_settings = nil
  m = OSC::Message.new('/status', 9091)
  @@osc_client.send(m)
  puts "Sending message: #{m}"
  t_start = Time.now
  while @@tracker_settings.nil? and (Time.now - t_start < 5)
    sleep 1
  end
  @@tracker_settings
end

get '/set/:tracker_id/:setting_name' do
  p params[:tracker_id], params[:setting_name], params[:value]
  set_tracker(params[:tracker_id], params[:setting_name], params[:value])
  puts "params[:tracker_id], params[:setting_name], params[:value]"
end