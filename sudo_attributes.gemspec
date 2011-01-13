# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sudo_attributes}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Brown"]
  s.date = %q{2011-01-12}
  s.description = %q{Adds 'sudo' methods to update protected ActiveRecord attributes with mass assignment}
  s.email = %q{github@lette.us}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION",
     "init.rb",
     "lib/sudo_attributes.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/sudo_attributes_spec.rb",
     "sudo_attributes.gemspec"
  ]
  s.homepage = %q{http://github.com/beerlington/sudo_attributes}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Override ActiveRecord protected attributes with mass assignment}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/sudo_attributes_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0"])
      s.add_development_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<rails>, [">= 2.3.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.0.0"])
      s.add_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 2.3.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.0.0"])
    s.add_dependency(%q<rails>, ["~> 3.0.0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 2.3.0"])
  end
end

