# -*- encoding: utf-8 -*-
require File.expand_path('../lib/heroku/forward/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'heroku-forward'
  s.version = Heroku::Forward::VERSION
  s.authors = ['Daniel Doubrovkine']
  s.email = 'dblock@dblock.org'
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.summary = "Beat Heroku's 60s boot timeout with a forward proxy."
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.name = 'heroku-forward'
  s.require_paths = ['lib']
  s.version = Heroku::Forward::VERSION
  s.required_ruby_version = '>= 1.9.3'
  s.extra_rdoc_files = `git ls-files -- *.md`.split("\n")
  s.homepage = 'http://github.com/dblock/heroku-forward'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.add_runtime_dependency('em-proxy', ['>= 0.1.8'])
  s.add_runtime_dependency('i18n', ['~> 0.6'])
  s.add_runtime_dependency('ffi', ['>= 0'])
  s.add_runtime_dependency('spoon', ['~> 0.0.1'])
  s.add_development_dependency('rspec', ['~> 3.3'])
  s.add_development_dependency('thin', ['~> 1.5'])
  s.add_development_dependency('unicorn', ['~> 4.5'])
  s.add_development_dependency('puma', ['~> 1.6'])
  s.add_development_dependency('em-http-request', ['~> 1.0'])
end
