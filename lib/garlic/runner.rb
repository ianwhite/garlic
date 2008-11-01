module Garlic
  # this class runs the top level garlic commands
  class Runner
    attr_reader :actor, :run_targets
    attr_accessor :repos, :targets, :all_targets, :repo_path, :work_path, :verbose

    def initialize(actor = nil, &block)
      @actor = actor
      self.repos = []
      self.targets = []
      self.all_targets = {}
      self.work_path = ".garlic"
      self.repo_path = "~/.garlic/repos"
      configure(&block) if block_given?
    end
    
    def configure(&block)
      Configurator.new(self, &block)
    end

    def repo(name)
      repos.detect {|r| r.name == name.to_s} or raise "Can't find repo: #{name}"
    end

    # convert a possible string argument into an array
    def run_targets=(targets)
      targets = targets.split(',').map{|t| t.strip} if targets.is_a?(String)
      @run_targets = targets
    end
    
    ### garlic commands ###
    
    # meta data about command methods which can be used by both rake and the cli tool
    @@commands, @@command_descriptions = [], {}
    
    class << self
      def define_command(name, desc, &block)
        @@commands << name
        @@command_descriptions[name] = desc
        define_method name, &block
      end
      
      def commands_with_description
        @@commands.map{|m| [m, @@command_descriptions[m]]}
      end
      
      def command_description(name)
        @@command_descriptions[name]
      end
      
      def commands
        @@command_descriptions.keys.map {|c| c.to_s}
      end
    end

    define_command :default, "Check repos, prepare TARGETs, and run TARGETs" do
      check_repos
      prepare
      run
    end
    
    define_command :all, "Install and update all repos, prepare and run TARGETs" do
      install_repos
      update_repos
      prepare
      run
    end
    
    define_command :install_repos, "Install required repositories" do
      repos.each {|repo| repo.install}
    end

    define_command :update_repos, "Update repositories" do
      repos.each {|repo| repo.update}
    end

    define_command :check_repos, "Check that repos are what they are supposed to be" do
      errors = []
      repos.each do |repo|
        begin
          repo.check
        rescue Exception => e
          errors << "- #{e.message}"
        end
      end
      errors.length == 0 or raise "\n#{errors.join("\n")}\n\nPlease remove these repos and run garlic install_repos\n"
    end

    define_command :reset_repos, "Reset all repos to their master branch" do
      repos.each {|repo| repo.reset}
    end

    define_command :clean, "Remove the work done by garlic" do
      rm_rf work_path
    end
    
    define_command :prepare, "Prepare each garlic TARGET" do
      begin
        determine_targets.each {|target| target.prepare }
      ensure
        repo('rails').checkout('master') # we get rails back to master if something goes wrong
      end
    end

    define_command :shell, "Run shell commands from stdin across specified targets" do |*path|
      shell = Shell.new(determine_targets)
      shell.current_path = path.first if path.first
      shell.run
    end
    
    define_command :run, "Run each garlic TARGET" do
      these_targets = determine_targets
      target_names, failed_names = these_targets.map{|t| t.name}, []

      puts "\n#{'='*78}\nTargets: #{target_names.join(', ')}\n#{'='*78}\n"
      these_targets.each do |target|
        puts "\n#{'-'*78}\nTarget: #{target.name} (commit #{target.rails_sha[0..6]}, run at #{Time.now})\n#{'-'*78}\n"
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

    def respond_to?(method)
      super(method) || (actor && actor.respond_to?(method))
    end

protected
    def method_missing(method, *args, &block)
      actor ? actor.send(method, *args, &block) : super
    end

    def determine_targets
      run_targets ? targets.select{|t| run_targets.include?(t.name)} : targets
    end
  end
end