require File.expand_path(File.join(File.dirname(__FILE__), '..', 'garlic'))

include Garlic

# configure the garlic runner
garlic ENV['CONFIG'] do
  verbose ['true', 'yes', '1'].include?(ENV['VERBOSE'])
  run_targets ENV['TARGETS'] || ENV['TARGET']
end

desc "Run garlic:default (CONFIG=path, TARGETS=list, VERBOSE=true)"
task :garlic do
  garlic.default
end

namespace :garlic do
  Garlic::Runner.commands_with_description.each do |command, description|
    desc description
    task command do
      garlic.send command
    end
  end
end