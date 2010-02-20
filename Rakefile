require 'rubygems'
require 'rake'

task :default => [:test]

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

desc "Run Flog against library (except tests)"
task :flog do
  puts %x[find ./lib -name *.rb | xargs flog]
end

desc "Run Roodi against library (except tests)"
task :roodi do
  puts %x[find ./lib -name *.rb | xargs roodi]
end

#
# Some monks like diamonds. I like gems.

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "riot_rails"
    gem.summary = "Riot specific test support for Rails apps"
    gem.description = "Riot specific test support for Rails apps. Protest the slow app."
    gem.email = "gus@gusg.us"
    gem.homepage = "http://github.com/thumblemonks/riot_rails"
    gem.authors = ["Justin 'Gus' Knowlden"]
    gem.add_dependency("riot", ">= 0.10.13.pre")
    gem.add_development_dependency("activerecord", ">= 3.0.0.pre")
    gem.add_development_dependency("actionpack", ">= 3.0.0.pre")
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
