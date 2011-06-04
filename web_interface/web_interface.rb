require 'sinatra'
require 'osc-ruby'

get '/set/:tracker_id/:setting_name' do
  p params[:tracker_id], params[:setting_name], params[:value]
  set_tracker(params[:tracker_id], params[:setting_name], params[:value])
  puts "params[:tracker_id], params[:setting_name], params[:value]"
end

def set_tracker(tracker_id, setting_name, value)
  osc_client = OSC::Client.new('localhost', 9090)
  address = "/set/#{tracker_id}"
  m = OSC::Message.new(address, setting_name, value.to_f)
  osc_client.send(m)
end