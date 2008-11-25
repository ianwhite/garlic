require 'rubygems'
require 'spec'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

require 'garlic'

spec = Gem::Specification.new do |s|
  s.name          = "garlic"
  s.version       = Garlic::Version::String
  s.summary       = "Set of commands/rake-tasks for CI against multiple version of rails/deps."
  s.description   = "Set of commands/rake-tasks for CI against multiple version of rails/deps."
  s.author        = "Ian White"
  s.email         = "ian.w.white@gmail.com"
  s.homepage      = "http://github.com/ianwhite/garlic/tree"
  s.has_rdoc      = true
  s.rdoc_options << "--title" << "Garlic" << "--line-numbers"
  s.test_files    = FileList["spec/**/*_spec.rb"]
  s.files         = FileList[
    "lib/**/*.rb", "templates/*.rb",
    "License.txt", "README.textile", "Todo.txt", "History.txt"
  ]
  s.executables   = ["garlic"]
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

desc "Generate garlic.gemspec file"
task :build do
  File.open('garlic.gemspec', 'w') { |f|
    f.write spec.to_ruby
  }
end

desc "Run the specs under spec"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts << "-c"
end

desc "Generate RCov reports"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.libs << 'lib'
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec', '--exclude', 'gems']
end