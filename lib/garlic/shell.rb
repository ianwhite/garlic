require 'fileutils'
begin
  require 'term/ansicolor'
rescue LoadError
end

module Garlic
  class Shell
    include FileUtils
    
    attr_reader :current_path
    
    def initialize(targets)
      @current_path = '.'
      @targets = targets
      raise "Garlic::Shell requires at least one target" if @targets.empty?
    end
    
    def current_path=(path)
      if path =~ /^(\/|\~)/
        STDOUT << red << "#{path}: only relative paths allowed\n" << clear
      else
        full_path = File.expand_path(File.join(@targets.first.path, current_path, path))
        if File.exists?(full_path)
          @current_path = full_path.include?(@targets.first.path) ? full_path.sub(@targets.first.path,'') : '.'
        else
          STDOUT << red << "#{path}: no such directory\n" << clear
        end
      end
    end
      
    def run
      STDOUT << green << "Garlic interactive session: type shell commands\n" << clear << prompt
      while (command = STDIN.gets) do
        command.strip!.empty? || process(command)
        STDOUT << prompt
      end
    rescue Interrupt
    ensure
      STDOUT << green << "Garlic interactive session ended\n" << clear
    end
    
    def process(command)
      if command =~ /^cd (.*)$/
        self.current_path = $1
      else
        @targets.each do |target|
          cd File.join(target.path, current_path) do
            STDOUT << magenta << target.name + ":\n" << clear
            system(command) || STDOUT << red << "command failed\n" << clear
          end
        end
      end
    end
    
  private
    [:red, :green, :magenta, :clear].each do |colour|
      define_method colour do
        Term::ANSIColor.send(colour) rescue ""
      end
    end
    
    def prompt
      green + "garlic:#{@current_path.sub(/^\.|\//,'')}> " + clear
    end
  end
end