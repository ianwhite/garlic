require 'rubygems'
require 'spec'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

require 'garlic'

spec = Gem::Specification.new do |s|
  s.name              = "garlic"
  s.version           = Garlic::Version::String
  s.summary           = "Lightweight set of rake tasks to help with CI."
  s.description       = "Lightweight set of rake tasks to help with CI."
  s.author            = "Ian White"
  s.email             = "ian.w.white@gmail.com"
  s.homepage          = "http://github.com/ianwhite/garlic/tree"
  s.has_rdoc          = false
  s.test_files        = FileList["spec/**/*_spec.rb"]
  s.files             = FileList[
    "lib/**/*.rb",
    "MIT-LICENSE",
    "README.rdoc",
    "TODO"
  ]
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