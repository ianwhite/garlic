$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require "garlic"

def garlic(&block)
  @garlic ||= Garlic::Garlic.new(self)
  @garlic.configure(&block) if block_given?
  @garlic
end

desc "Prepare and run specified TARGET(S) (default all)"
task :garlic => ['garlic:prepare_targets', 'garlic:run_targets']

namespace :garlic do
  desc "Install repos, update repos, check repos, prepare targets, and run CI in them"
  task :all => [:install_repos, :update_repos, :check_repos, :prepare_targets, :run_targets]
  
  desc "Prepare specified TARGET(S) (default all)"
  task :prepare_targets do
    garlic.prepare
  end
  
  desc "Clean all of the work away, but not the repos"
  task :clean do
    garlic.clean
  end

  desc "Run the CI 'run' task in specified TARGET(S) (default all)"
  task :run_targets do
    garlic.run
  end
  
  desc "Install required repositories"
  task :install_repos do
    garlic.install_repos
  end

  desc "Update installed repositories"
  task :update_repos do
    garlic.update_repos
  end

  desc "Check that repositories are installed"
  task :check_repos do
    garlic.check_repos
  end
  
  desc "Reset all repos back to master"
  task :reset_repos do
    garlic.reset_repos
  end
end