task :default => :spec

task :spec do
  cd('spec') { sh 'spec *' }
end

task :specdoc do
  cd('spec') { puts `spec * -f specdoc` }
end