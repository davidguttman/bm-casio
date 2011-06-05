require 'ostruct'
require 'json/pure'

class SettingsTracker
  
  def initialize(opts={})
    @settings = {}
  end
  
  def add_setting(setting)
    if setting.class == String
      setting = JSON.parse(setting)
    end
    if setting.class == Hash
      setting = TrackerSetting.new(setting)
    end
    @settings[setting.name] = setting
  end
  
  def slider(name, default, range, group=nil)
    add_setting(:name => name, :default => default, :value => default, :max => range.end, :min => range.begin, :ui_type => 'slider', :group => group)
  end
  
  def [](setting_name)
    @settings[setting_name].value
  end
  
  def []=(setting_name, setting_value)
    @settings[setting_name].value = setting_value
  end
  
  def to_h
    settings = {}
    @settings.each do |setting_name, setting|
      settings[setting.name] = setting.to_h
    end
    settings
  end
  
  def to_json
    self.to_h.to_json
  end
  
end

class TrackerSetting < OpenStruct
  
  def norm_value
    (value - min) / (max - min)
  end
  
  def to_h
    hash = {
      "name" => name,
      "value" => value,
      "min" => min,
      "max" => max,
      "default" => default,
      "group" => group,
      "norm_value" => norm_value,
      "ui_type" => ui_type
    }
    p hash
    return hash
  end
  
  def to_json
    self.to_h.to_json
  end
  
end