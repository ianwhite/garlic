require File.expand_path(File.join(File.dirname(__FILE__), 'garlic'))

def garlic(&block)
  @garlic ||= Garlic.new(self)
  @garlic.configure(&block) if block_given?
  @garlic
end

namespace :garlic do
  desc "Install repos, prepare targets, and run CI in them"
  task :cruise => [:install_repos, :prepare, :run]
  
  desc "Prepare each of the rails targets"
  task :prepare => :check_repos do
    cd('garlic') { garlic.prepare }
  end

  desc "Run the CI task in all targets"
  task :run do
    cd('garlic') { garlic.run }
  end

  desc "Install required repositories"
  task :install_repos do
    cd('garlic') { garlic.install_repos }
  end

  desc "Update installed repositories"
  task :update_repos do
    cd('garlic') { garlic.update_repos }
  end

  desc "Check that repositories are installed"
  task :check_repos do
    cd('garlic') { garlic.check_repos }
  end
  
  desc "Reset all repos back to master"
  task :reset_repos do
    cd('garlic') { garlic.reset_repos }
  end
end