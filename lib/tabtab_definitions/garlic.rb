require "garlic/session"
require "garlic/generator"

TabTab::Definition.register('garlic', :import => '--help') do |g|
  Garlic::Session.commands.each do |c|
    g.command c
  end
  
  g.command :generate do
    class << self
      include Garlic::Generator
    end
    available_templates
  end
end