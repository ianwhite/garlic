require 'rubygems'
require 'spec'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

require 'garlic'

begin
  require 'jeweler'
  
  Jeweler::Tasks.new do |s|
    s.name = "garlic"
    s.version = Garlic::Version::String
    s.summary = "Test your project across multiple versions of rails/dependencies"
    s.description = "CI tool to test your project across multiple versions of rails/dependencies"
    s.email = "ian.w.white@gmail.com"
    s.homepage = "http://github.com/ianwhite/garlic"
    s.authors = ["Ian White"]
    s.rubyforge_project = 'garlic'
  end
  
  Jeweler::GemcutterTasks.new

  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
  
rescue LoadError
  puts "Jeweler not available for gem tasks. Install it with: sudo gem install jeweler"
end

begin
  require 'hanna/rdoctask'
rescue LoadError
end  

Rake::RDocTask.new(:doc) do |d|
  d.options << '--all'
  d.rdoc_dir = 'doc'
  d.main     = 'README.textile'
  d.title    = "garlic API Docs"
  d.rdoc_files.include('README.rdoc', 'History.txt', 'License.txt', 'Todo.txt', 'VERSION', 'lib/**/*.rb')
end
task :rdoc => :doc

Spec::Rake::SpecTask.new(:spec) do |t|
  t.warning = true
end
task :default => :spec



