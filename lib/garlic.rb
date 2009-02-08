require "garlic/session"
require "garlic/configurator"
require "garlic/repo"
require "garlic/target"
require "garlic/generator"
require "garlic/shell"

module Garlic
  include Generator
  
  module Version
    Major = 0
    Minor = 1
    Tiny  = 8
    
    String = [Major, Minor, Tiny].join('.')
  end
  
  # return the current garlic session
  def garlic(config = nil, &block)
    @garlic ||= Garlic::Session.new(self)
    load_config(config)
    @garlic.configure(&block) if block_given?
    @garlic
  end
  
  # load config from 
  def load_config(config = nil)
    unless @garlic_config_file
      @garlic_config_file = config || "garlic.rb"
      unless File.exists?(@garlic_config_file)
        raise "garlic requries a configuration file (can't find #{@garlic_config_file}), try:\n  garlic generate [#{available_templates.join('|')}] > garlic.rb"
      end
      eval File.read(@garlic_config_file)
    end
  end
end