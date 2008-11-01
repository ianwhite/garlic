# typical rspec garlic configuration

garlic do
  # this plugin
  repo "#{plugin}", :path => '.'
  
  # other repos
  repo "rails", :url => "git://github.com/rails/rails"
  repo "rspec", :url => "git://github.com/dchelimsky/rspec"
  repo "rspec-rails", :url => "git://github.com/dchelimsky/rspec-rails"
  
  # targets
  target "edge", :branch => 'origin/master'
  target "2.1", :branch => "origin/2-1-stable"
  target "2.0", :branch => "origin/2-0-stable"
  target "1.2", :branch => "origin/1-2-stable"
  
  # all targets
  all_targets do
    prepare do
      plugin "#{plugin}", :clone => true # so we can work in targets
      plugin "rspec"
      plugin "rspec-rails" do
        sh "script/generate rspec -f"
      end
    end
      
    run do
      cd "vendor/plugins/#{plugin}" do
        sh "rake"
      end
    end
  end
end