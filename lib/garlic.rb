class Garlic
  attr_reader :actor
  attr_accessor :repos, :targets, :all_targets
  
  def initialize(actor)
    @runners = {}
    @actor = actor
    self.repos = {}
    self.targets = {}
    self.all_targets = {}
  end
  
  def method_missing(method, *args, &block)
    return actor.send(method, *args, &block)
  end
  
  def respond_to?(method)
    super(method) || actor.respond_to?(method)
  end
  
  def configure(&block)
    Configurator.new(self, &block)
  end
  
  def install_repos
    repos.each do |repo, options|
      if File.exists?("repos/#{repo}")
        puts "\nSkipping #{repo}, as it exists"
      else
        puts "\nInstalling #{repo}..."
        sh "git clone #{options[:url]} repos/#{repo}"
      end
    end
    puts "\nInstalled: #{repos.keys.join(", ")}"
  end
  
  def update_repos
    repos.each do |repo, options|
      if repo_path?("repos/#{repo}")
        puts "\nUpdating #{repo}..."
        cd "repos/#{repo}" do
          sh "git pull", :verbose => false
        end
      elsif File.exists?("repos/#{repo}")
        raise "\nRepo #{repo} (repos/#{repo}) is not a git repo.\nRemove it and run rake install_repos\n\n"
      else
        raise "\nRepo #{repo} missing.\nPlease run rake install_repos\n\n"
      end
    end
  end
  
  def check_repos
    errors = []
    repos.each do |repo, options|
      if !repo_path?("repos/#{repo}")
        errors << " - #{repo} is missing, or is not a git repo"
      elsif !same_git_url?(options[:url], (url = origin_of("repos/#{repo}"))) 
        errors << " - #{repo}'s url has changed from #{url} to #{options[:url]}"
      end
    end
    errors.length == 0 or raise <<-eod

#{errors.join("\n")}

Please remove these repositories and run rake garlic:install_repos
eod
  end
  
  def reset_repos
    repos.keys.each do |repo|
      cd "repos/#{repo}" do
        sh "git reset --hard master"
      end
    end
  end
  
  def prepare
    repos.key?('rails') or raise "\n\ngarlic requires a rails repo.\n\n"
    targets.each do |target, options|
      options = all_targets.merge(options)
      puts "\nInstalling target #{target} (#{options[:tree]})"
      install_rails(target, options[:tree])
      run_for_target(target, &options[:prepare]) if options[:prepare]
    end
  ensure
    checkout_dependency('rails', 'master') # we get repo back to master if something goes wrong
  end
  
  def run
    failed = []
    these_targets = determine_targets

    puts "\n#{'='*78}\nTargets: #{these_targets.join(', ')}\n#{'='*78}\n"
    these_targets.each do |target|
      puts "\n#{'-'*78}\nTarget: #{target}\n#{'-'*78}\n"
      options = all_targets.merge(targets[target])
      begin
        run_for_target(target, :exec_path => "work/#{target}", &(options[:run] || lambda { sh "rake" }))
        puts "\ntarget: #{target} PASS"
      rescue
        puts "\ntarget: #{target} FAIL"
        failed << target
      end
    end

    puts "\n#{'='*78}\n"
    if failed.length > 0
      raise "The following targets passed: #{(these_targets - failed).join(', ')}.\n\nThe following targets FAILED: #{failed.join(', ')}.\n\n"
    else
      puts "All specified targets passed: #{these_targets.join(', ')}.\n\n"
    end
  end
  
  def extract_tree_ish_from!(options)
    [:tree_ish, :tree, :branch, :tag, :commit, :sha].each do |key|
      if val = options.delete(key)
        return val
      end
    end
    nil
  end
  
private
  # presumes
  #  - that repository's HEAD is in the desired location
  #  - that the working directory is garlic main (the one containing repos)
  def install_dependency(repo, dest, options = {}, &block)
    vendor_sha_file = "#{dest}/.git_sha"
    vendor_sha = File.read(vendor_sha_file) rescue nil
    head_sha = commit_sha_of("repos/#{repo}")
  
    if head_sha == vendor_sha
      puts "#{dest} is up to date"
    else
      puts "#{dest} needs update, exporting archive from repos/#{repo}..."
      rm_rf dest; mkdir_p dest
    
      cd "repos/#{repo}" do
        sh "git archive --format=tar HEAD > ../../#{dest}/#{repo}.tar", :verbose => false
      end
    
      cd(dest) do
        `tar -x -f #{repo}.tar`
        rm "#{repo}.tar"
      end
      
      cd(options[:exec_path] || '.') do
        yield if block_given?
      end
    
      # store the commit_sha in the vendor path
      File.open(vendor_sha_file, 'w+') {|f| f << head_sha}
    
      puts "Done"
    end
  end
  
  def install_rails(rails, tree_ish)
    checkout_dependency('rails', tree_ish)

    if File.exists?("work/#{rails}")
      puts "rails app in work/#{rails} exists"
    else
      puts "Creating rails app in work/#{rails}..."
      sh "ruby repos/rails/railties/bin/rails work/#{rails}", :verbose => false
    end

    install_dependency('rails', "work/#{rails}/vendor/rails", :exec_path => "work/#{rails}") do
      sh "rake rails:update"
    end
  end

  def run_for_target(target, options = {}, &block)
    cd(options[:exec_path] || ".") do
      TargetRunner.new(self, target).instance_eval(&block)
    end
  end
  
  def checkout_dependency(repo, tree_ish)
    cd "repos/#{repo}" do
      sh "git checkout -q #{tree_ish}", :verbose => false
    end
  end

  def repo_path?(path)
    File.directory?(File.join(path, '.git'))
  end

  def origin_of(path)
    match = `cd #{path}; git remote show -n origin`.match(/URL: (.*)\n/)
    (match && match[1])
  end

  def same_git_url?(a, b)
    # remove / and .git from end
    a = a.sub(/\/?(\.git)?$/, '')
    b = b.sub(/\/?(\.git)?$/, '')
    a == b
  end
  
  def commit_sha_of(path)
    cd path do
      return `git log HEAD -1 --pretty=format:\"%H\"`
    end
  end
   
  def determine_targets
    these_targets = ENV['TARGETS'] || ENV['TARGET'] || targets.keys.join(",")
    these_targets = [*these_targets.split(',')] & targets.keys
    these_targets.length == 0 and raise <<-eod

No targets specified.
Did you mean one or more of: #{targets.keys.join(', ')}?

e.g. rake run_targets TARGET=#{targets.keys.first}
     rake run_targets TARGETS=#{targets.keys.first},#{targets.keys.last}
     rake run_targets

eod
    these_targets
  end
  
  class TargetRunner
    attr_reader :garlic, :target
    
    def initialize(garlic, target)
      @garlic = garlic
      @target = target
    end
    
    def method_missing(method, *args, &block)
      garlic.send(method, *args, &block)
    end

    def respond_to?(method)
      super(method) || garlic.respond_to?(method)
    end
    
    def plugin(plugin, options = {}, &block)
      if tree_ish = garlic.extract_tree_ish_from!(options)
        garlic.send(:checkout_dependency, plugin, tree_ish)
      end
      garlic.send(:install_dependency, plugin, "work/#{target}/vendor/plugins/#{plugin}", :exec_path => "work/#{target}", &block)
    end

    def dependency(repo, dest, options = {}, &block)
      # TODO
    end
  end
  
  class Configurator
    attr_reader :garlic
    
    def initialize(garlic, &block)
      @garlic = garlic
      instance_eval(&block)
    end
    
    def repo(name, options = {}, &block)
      options[:url] or raise ArgumentError, "repo requires a :url"
      options[:url] = File.expand_path(options[:url]) unless options[:url] =~ /^\w+(:|@)/
      garlic.repos[name.to_s] = options
    end
    
    def target(name, options = {}, &block)
      options[:tree] = garlic.extract_tree_ish_from!(options) || 'master'
      options[:repo] ||= 'rails'
      BlockParser.new(options, :prepare, :run, &block) if block_given?
      garlic.targets[name.to_s] = options
    end
  
    def all_targets(options = {}, &block)
      BlockParser.new(options, :prepare, :run, &block) if block_given?
      garlic.all_targets = options
    end
    
    class BlockParser
      attr_reader :options, :whitelist

      def initialize(options, *whitelist, &block)
        @options = options
        @whitelist = whitelist
        instance_eval(&block)
      end
      
      def method_missing(method, *args, &block)
        if block_given? && args.empty? && (whitelist.empty? || whitelist.include?(method))
          options[method.to_sym] = block
        else
          raise ArgumentError, "Don't know how to parse #{method} #{args.inspect unless args.empty?}"
        end
      end
    end
  end
end