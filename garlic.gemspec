# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{garlic}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ian White"]
  s.date = %q{2008-10-11}
  s.description = %q{Lightweight set of rake tasks to help with CI.}
  s.email = %q{ian.w.white@gmail.com}
  s.files = ["lib/garlic/configurator.rb", "lib/garlic/garlic.rb", "lib/garlic/repo.rb", "lib/garlic/target.rb", "lib/garlic.rb", "lib/garlic_tasks.rb", "MIT-LICENSE", "README.rdoc", "TODO", "spec/garlic/repo_spec.rb"]
  s.homepage = %q{http://github.com/ianwhite/garlic/tree}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Lightweight set of rake tasks to help with CI.}
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
