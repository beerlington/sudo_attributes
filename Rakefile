require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sudo_attributes"
    gem.summary = %Q{Override ActiveRecord protected attributes with mass assignment}
    gem.description = %Q{Adds 'sudo' methods to update protected ActiveRecord attributes with mass assignment}
    gem.email = "github@lette.us"
    gem.homepage = "http://github.com/beerlington/sudo_attributes"
    gem.authors = ["Peter Brown"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "sqlite3-ruby"
    gem.add_dependency "rails", ">= 2.3.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sudo_attributes #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
