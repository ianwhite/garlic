module Garlic
  class Garlic
    attr_reader :actor
    attr_accessor :repos, :targets, :all_targets, :repo_path, :work_path

    def initialize(actor = nil, &block)
      @runners = {}
      @actor = actor
      self.repos = []
      self.targets = []
      self.all_targets = {}
      self.work_path = "garlic/work"
      self.repo_path = "garlic/repos"
      configure(&block) if block_given?
    end

    def method_missing(method, *args, &block)
      actor ? actor.send(method, *args, &block) : super
    end

    def respond_to?(method)
      super(method) || (actor && actor.respond_to?(method))
    end

    def configure(&block)
      Configurator.new(self, &block)
    end

    def repo(name)
      repos.detect {|r| r.name == name.to_s} or raise "Can't find repo: #{name}"
    end
    
    def install_repos
      repos.each {|repo| repo.install}
    end

    def update_repos
      repos.each {|repo| repo.update}
    end

    def check_repos
      errors = []
      repos.each do |repo|
        begin
          repo.check
        rescue Exception => e
          errors << "- #{e.message}"
        end
      end
      errors.length == 0 or raise "\n#{errors.join("\n")}\n\nPlease remove these repos and run rake garlic:install_repos\n"
    end

    def reset_repos
      repos.each {|repo| repo.reset}
    end

    def prepare
      targets.each {|target| target.prepare }
    ensure
      repo('rails').checkout('master') # we get rails back to master if something goes wrong
    end

    def run
      these_targets = determine_targets
      target_names, failed_names = these_targets.collect {|t| t.name}, []

      puts "\n#{'='*78}\nTargets: #{target_names.join(', ')}\n#{'='*78}\n"
      these_targets.each do |target|
        puts "\n#{'-'*78}\nTarget: #{target.name}\n#{'-'*78}\n"
        begin
          target.run
          puts "\ntarget: #{target.name} PASS"
        rescue
          puts "\ntarget: #{target.name} FAIL"
          failed_names << target.name
        end
      end
      puts "\n#{'='*78}\n"
      failed_names.length > 0 and raise "The following targets passed: #{(target_names - failed_names).join(', ')}.\n\nThe following targets FAILED: #{failed_names.join(', ')}.\n\n"
      puts "All specified targets passed: #{target_names.join(', ')}.\n\n"
    end

private
    def determine_targets
      if names =ENV['TARGETS'] || ENV['TARGET']
        names = [*names.split(',')]
        these_targets = targets.select{|t| names.include?(t.name)}
      else
        these_targets = targets
      end
      these_targets.length == 0 and raise "\n\nNo targets found, use TARGET=name, or TARGETS=name1,name2"
      these_targets
    end
  end
end