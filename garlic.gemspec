# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{garlic}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ian White"]
  s.date = %q{2008-11-23}
  s.default_executable = %q{garlic}
  s.description = %q{Set of commands/rake-tasks for CI against multiple version of rails/deps.}
  s.email = %q{ian.w.white@gmail.com}
  s.executables = ["garlic"]
  s.files = ["lib/garlic/configurator.rb", "lib/garlic/generator.rb", "lib/garlic/repo.rb", "lib/garlic/session.rb", "lib/garlic/shell.rb", "lib/garlic/target.rb", "lib/garlic/tasks.rb", "lib/garlic.rb", "lib/tabtab_definitions/garlic.rb", "templates/default.rb", "templates/rspec.rb", "templates/shoulda.rb", "MIT-LICENSE", "README.textile", "TODO", "CHANGELOG", "spec/garlic/repo_spec.rb", "bin/garlic"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/ianwhite/garlic/tree}
  s.rdoc_options = ["--title", "Garlic", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Set of commands/rake-tasks for CI against multiple version of rails/deps.}
  s.test_files = ["spec/garlic/repo_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
