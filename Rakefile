# encoding: utf-8

require 'rubygems'
require 'rake'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "sudo_attributes"
  gem.summary = %Q{Override ActiveRecord protected attributes with mass assignment}
  gem.description = %Q{Adds 'sudo' methods to update protected ActiveRecord attributes with mass assignment}
  gem.email = "github@lette.us"
  gem.homepage = "http://github.com/beerlington/sudo_attributes"
  gem.authors = ["Peter Brown"]
  gem.license = "MIT"
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "classy_enum #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
