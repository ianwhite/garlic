module Garlic
  # This class represents a local git repo
  class Repo
    attr_reader :url, :local, :path, :name

    def initialize(options = {})
      if @url = options[:url]
        @url = File.expand_path(@url) unless options[:url] =~ /^\w+(:|@)/
      end
      
      @path = options[:path] or raise ArgumentError, "Repo requires a :path"
      @path = File.expand_path(@path)
      
      @local = options[:local]
      @local = File.expand_path(@local) if @local
      
      @name = options[:name] || File.basename(@path)
    end

    class<<self
      def path?(path)
        File.directory?(File.join(path, '.git'))
      end

      def tree_ish(options)
        [:tree_ish, :tree, :branch, :tag, :commit, :sha].each do |key|
          return options[key] if options[key]
        end
        nil
      end
      
      def head_sha(path)
        `cd #{path}; git log HEAD -1 --pretty=format:\"%H\"`
      end
    end
    
    def install
      if File.exists?(path)
        puts "\nSkipping #{name}, as it exists"
      else
        puts "\nInstalling #{name}"
        sh "git clone #{url}#{" --reference #{local}" if local} #{path}"
      end
    end

    def update
      puts "\nUpdating #{name}..."
      if Repo.path?(path)
        if url
          begin
            checkout 'master'
            cd(path) { sh "git pull origin master", :verbose => false }
          rescue Exception => e
            puts "\n\nIt seems there was a problem.\nTry running rake garlic:reset_repos\n\n"
            raise e
          end
        else
          puts "No url for #{name} given, so not updating"
        end
      elsif File.exists?(path)
        raise "\nRepo #{name} (#{path}) is not a git repo.\nRemove it and run rake garlic:install_repos\n\n"
      else
        raise "\nRepo #{name} missing from #{path}.\nPlease run rake garlic:install_repos\n\n"
      end
    end

    def check
      if !Repo.path?(path)
        raise "#{name} is missing from #{path}, or is not a git repo"
      elsif url && !same_url?(origin_url)
        raise "#{name}'s url has changed from #{url} to #{origin_url}"
      end
    end

    def reset
      cd(path) { sh "git reset --hard master" }
      checkout('master')
    end

    def checkout(tree_ish)
      cd(path) { sh "git checkout -q #{tree_ish}", :verbose => false }
    end
    
    def export_to(export_path)
      rm_rf export_path; mkdir_p export_path
      cd(path) do
        sh "git archive --format=tar HEAD > #{File.join(export_path, "#{name}.tar")}", :verbose => false
      end
      cd(export_path) do
        `tar -x -f #{name}.tar`
        rm "#{name}.tar"
      end
    end
    
    def clone_to(clone_path)
      mkdir_p File.dirname(clone_path)
      cd (File.dirname(clone_path)) do
        sh "git clone #{path} #{clone_path}"
      end
    end

    def origin_url
      unless @origin_url
        match = `cd #{path}; git remote show -n origin`.match(/URL: (.*)\n/)
        @origin_url = (match && match[1])
      end
      @origin_url
    end

    def same_url?(url)
      self.url.sub(/\/?(\.git)?$/, '') == url.sub(/\/?(\.git)?$/, '')
    end

    def head_sha
      Repo.head_sha(path)
    end
  end
end
