module Garlic
  class Configurator
    attr_reader :garlic

    def initialize(garlic, &block)
      @garlic = garlic
      instance_eval(&block) if block_given?
    end

    def work_path(path)
      garlic.work_path = path
    end

    def repo_path(path)
      garlic.repo_path = path
    end

    def repo(name, options = {})
      options[:path] = "#{garlic.repo_path}/#{name}"
      garlic.repos << Repo.new(options)
    end

    def all_targets(options = {}, &block)
      BlockParser.new(options, [:prepare, :run], &block) if block_given?
      garlic.all_targets = options
    end
    
    def target(name, options = {}, &block)
      options[:path] = "#{garlic.work_path}/#{name}"
      BlockParser.new(options, [:prepare, :run], &block) if block_given?
      garlic.targets << Target.new(garlic, options)
    end

    class BlockParser
      attr_reader :options, :whitelist

      def initialize(options, whitelist = [], &block)
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