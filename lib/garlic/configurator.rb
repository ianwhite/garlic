module Garlic
  # Configures the garlic runner in a decalarative style
  class Configurator
    attr_reader :garlic

    def initialize(garlic, &block)
      @garlic = garlic
      instance_eval(&block) if block_given?
    end

    def repo(name, options = {})
      options[:name] = name
      options[:path] ||= "#{garlic.repo_path}/#{name}"
      garlic.repos << Repo.new(options)
    end
    
    def target(name, options = {}, &block)
      options[:name] = name
      options[:path] = "#{garlic.work_path}/#{name}"
      BlockParser.new(options, [:prepare, :run], &block) if block_given?
      garlic.targets << Target.new(garlic, options)
    end

    def respond_to?(method)
      super || garlic.respond_to?("#{method}=")
    end
    
  protected
    def method_missing(attribute, value)
      if garlic.respond_to?("#{attribute}=")
        garlic.send("#{attribute}=", value)
      else
        super
      end
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
