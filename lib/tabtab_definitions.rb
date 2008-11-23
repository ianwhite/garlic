require "garlic/session"

TabTab::Definition.register('garlic', :import => '--help') do |g|
  Garlic::Session.commands.each do |c|
    g.command c
  end
end