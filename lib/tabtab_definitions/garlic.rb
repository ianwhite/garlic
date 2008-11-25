require "garlic/session"

TabTab::Definition.register('garlic', :import => '--help') do |g|
  Garlic::Session.commands.each do |c|
    g.command c
  end
  
  g.command :generate do 
    `ls ~/.garlic/templates`.split.map{|t| t.sub('.rb','')}
  end
end