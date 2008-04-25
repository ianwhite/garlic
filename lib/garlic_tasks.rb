$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require "garlic"

def garlic(&block)
  @garlic ||= Garlic::Garlic.new(self, &block)
end

namespace :garlic do
  desc "Install repos, update repos, prepare targets, and run CI in them"
  task :all => [:install_repos, :update_repos, :prepare, :run]
  
  desc "Prepare each of the rails targets"
  task :prepare => :check_repos do
    garlic.prepare
  end

  desc "Run the CI task in all targets"
  task :run do
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