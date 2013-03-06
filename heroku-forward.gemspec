# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "heroku-forward"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Doubrovkine"]
  s.date = "2013-01-25"
  s.email = "dblock@dblock.org"
  s.extra_rdoc_files = [
    "LICENSE.md",
    "README.md"
  ]
  s.files = [
    "lib/heroku-forward.rb",
    "lib/heroku/forward.rb",
    "lib/heroku/forward/backends.rb",
    "lib/heroku/forward/backends/base.rb",
    "lib/heroku/forward/backends/thin.rb",
    "lib/heroku/forward/backends/unicorn.rb",
    "lib/heroku/forward/backends/puma.rb",
    "lib/heroku/forward/config/locales/en.yml",
    "lib/heroku/forward/errors.rb",
    "lib/heroku/forward/errors/backend_failed_to_start_error.rb",
    "lib/heroku/forward/errors/heroku_forward_error.rb",
    "lib/heroku/forward/errors/missing_backend_application_error.rb",
    "lib/heroku/forward/errors/missing_backend_option_error.rb",
    "lib/heroku/forward/proxy.rb",
    "lib/heroku/forward/proxy/server.rb",
    "lib/heroku/forward/utils/dir.rb",
    "lib/heroku/forward/version.rb"
  ]
  s.homepage = "http://github.com/dblock/heroku-forward"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Beat Heroku's 60s boot timeout with a forward proxy."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<em-proxy>, [">= 0.1.8"])
      s.add_runtime_dependency(%q<i18n>, ["~> 0.6"])
      s.add_runtime_dependency(%q<ffi>, [">= 0"])
      s.add_runtime_dependency(%q<spoon>, ["~> 0.0.1"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6"])
      s.add_development_dependency(%q<thin>, ["~> 1.5"])
      s.add_development_dependency(%q<unicorn>, ["~> 4.5"])
      s.add_development_dependency(%q<puma>, ["~> 1.6"])
      s.add_development_dependency(%q<em-http-request>, ["~> 1.0"])
    else
      s.add_dependency(%q<em-proxy>, [">= 0.1.8"])
      s.add_dependency(%q<i18n>, ["~> 0.6"])
      s.add_dependency(%q<ffi>, [">= 0"])
      s.add_dependency(%q<spoon>, ["~> 0.0.1"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<rspec>, ["~> 2.6"])
      s.add_dependency(%q<jeweler>, ["~> 1.6"])
      s.add_dependency(%q<thin>, ["~> 1.5"])
      s.add_dependency(%q<unicorn>, ["~> 4.5"])
      s.add_dependency(%q<puma>, ["~> 1.6"])
      s.add_dependency(%q<em-http-request>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<em-proxy>, [">= 0.1.8"])
    s.add_dependency(%q<i18n>, ["~> 0.6"])
    s.add_dependency(%q<ffi>, [">= 0"])
    s.add_dependency(%q<spoon>, ["~> 0.0.1"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<rspec>, ["~> 2.6"])
    s.add_dependency(%q<jeweler>, ["~> 1.6"])
    s.add_dependency(%q<thin>, ["~> 1.5"])
    s.add_dependency(%q<unicorn>, ["~> 4.5"])
    s.add_dependency(%q<puma>, ["~> 1.6"])
    s.add_dependency(%q<em-http-request>, ["~> 1.0"])
  end
end

