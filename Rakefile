require 'rubygems'
require 'bundler'

require File.expand_path('../lib/heroku/forward/version', __FILE__)

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
  gem.name = "heroku-forward"
  gem.homepage = "http://github.com/dblock/heroku-forward"
  gem.license = "MIT"
  gem.summary = "Beat Heroku's 60s boot timeout with a forward proxy."
  gem.email = "dblock@dblock.org"
  gem.version = Heroku::Forward::VERSION
  gem.authors = [ "Daniel Doubrovkine" ]
  gem.files = Dir.glob('lib/**/*')
end

Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

