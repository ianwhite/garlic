require File.expand_path(File.join(File.dirname(__FILE__), 'garlic'))

def garlic(&block)
  @garlic ||= Garlic.new(self)
  @garlic.configure(&block) if block_given?
  @garlic
end

namespace :garlic do
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
end