require "garlic/garlic"
require "garlic/configurator"
require "garlic/repo"
require "garlic/target"

module Garlic
  module Version
    Major = 0
    Minor = 1
    Tiny  = 0
    
    String = [Major, Minor, Tiny].join('.')
  end
end