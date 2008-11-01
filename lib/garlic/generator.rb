module Garlic
  # generate a garlic config file
  module Generator
    include FileUtils
    
    TEMPLATES_PATH = File.expand_path("~/.garlic/templates")
    
    def generate_config(template = 'default', plugin = nil)
      raise "unknown template: #{template}.\nUse one of #{available_templates.join(', ')} or create your own in #{TEMPLATES_PATH}" unless available_templates.include?(template)
      plugin ||= File.basename(File.expand_path('.'))
      puts eval("<<-EOD\n" + File.read(File.join(TEMPLATES_PATH, "#{template}.rb")) + "\nEOD")
    end
    
    def available_templates
      copy_templates unless File.exists?(TEMPLATES_PATH)
      Dir[File.join(TEMPLATES_PATH, '*')].map {|f| File.basename(f.sub(/.rb$/,'')) }
    end
    
  protected
    def copy_templates
      mkdir_p TEMPLATES_PATH
      Dir[File.join(File.dirname(__FILE__), '../../templates/*.rb')].each do |file|
        cp file, File.join(TEMPLATES_PATH, File.basename(file))
      end
    end
  end
end