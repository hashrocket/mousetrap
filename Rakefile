require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mousetrap"
    gem.summary = %Q{CheddarGetter API Client in Ruby}
    gem.description = %Q{CheddarGetter API Client in Ruby}
    gem.email = "jonlarkowski@gmail.com"
    gem.homepage = "http://github.com/hashrocket/mousetrap"
    gem.authors = ["Jon Larkowski", "Sandro Turriate", "Wolfram Arnold", "Corey Grusden"]
    gem.add_dependency 'httparty', '>= 0.6.1'
    gem.add_development_dependency "activesupport", '>= 2.3.3'
    gem.add_development_dependency "rspec", '>= 1.2.9'
    gem.add_development_dependency 'factory_girl', '>= 1.2.3'
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.spec_opts = ['--options', 'spec/spec.opts']
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mousetrap #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
