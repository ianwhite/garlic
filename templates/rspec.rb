# typical rspec garlic configuration

garlic do
  # this plugin
  repo "#{plugin}", :path => '.'
  
  # other repos
  repo "rails", :url => "git://github.com/rails/rails"
  repo "rspec", :url => "git://github.com/dchelimsky/rspec"
  repo "rspec-rails", :url => "git://github.com/dchelimsky/rspec-rails"
  
  # target railses
  ['origin/master', 'origin/2-2-stable', 'origin/2-1-stable', 'origin/2-0-stable'].each do |rails|
    
    # declare how to prepare, and run each CI target
    target "Rails: #{rails}", :tree_ish => rails do
      prepare do
        plugin "#{plugin}", :clone => true # so we can work in targets
        plugin "rspec"
        plugin "rspec-rails" do
          `script/generate rspec -f`
        end
      end
    
      run do
        cd "vendor/plugins/#{plugin}" do
          sh "rake"
        end
      end
    end
  end
end