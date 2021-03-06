# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{garlic}
  s.version = "0.1.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ian White"]
  s.date = %q{2009-10-05}
  s.default_executable = %q{garlic}
  s.description = %q{CI tool to test your project across multiple versions of rails/dependencies}
  s.email = %q{ian.w.white@gmail.com}
  s.executables = ["garlic"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "History.txt",
     "License.txt",
     "README.rdoc",
     "Rakefile",
     "Todo.txt",
     "VERSION",
     "bin/garlic",
     "garlic.gemspec",
     "lib/garlic.rb",
     "lib/garlic/configurator.rb",
     "lib/garlic/generator.rb",
     "lib/garlic/repo.rb",
     "lib/garlic/session.rb",
     "lib/garlic/shell.rb",
     "lib/garlic/target.rb",
     "lib/garlic/tasks.rb",
     "lib/tabtab_definitions/garlic.rb",
     "sh/garlic.sh",
     "spec/garlic/repo_spec.rb",
     "spec/spec_helper.rb",
     "templates/default.rb",
     "templates/rspec.rb",
     "templates/shoulda.rb"
  ]
  s.homepage = %q{http://github.com/ianwhite/garlic}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{garlic}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Test your project across multiple versions of rails/dependencies}
  s.test_files = [
    "spec/garlic/repo_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
