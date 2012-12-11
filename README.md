Heroku::Foward [![Build Status](https://travis-ci.org/dblock/heroku-forward.png?branch=master)](https://travis-ci.org/dblock/heroku-forward)
==============

Beat Heroku's 60 seconds timeout with a forward proxy.

What's this?
------------

[Heroku](http://www.heroku.com/) will report an application crashing and yield an `R10 Boot Timeout` error when a web process took longer than 60 seconds to bind to its assigned `$PORT`. This error is often caused by a process being unable to reach an external resource, such as a database or because Heroku is pretty slow and you have a lot of gems in your `Gemfile`.

This gem implements a forward proxy using [em-proxy](https://github.com/igrigorik/em-proxy). This proxy is booted almost immediately, binding to the port assigned by Heroku. Heroku now reports the dyno up. The proxy then spawns your application's web server and establishes a connection over a unix domain socket (a file) between the proxy and the application. Once the application is ready, it will be able to serve HTTP requests normally. Until then requests may queue and some may timeout depending on how long it actually takes to start.

Usage
-----

Add `heroku-forward` and `em-proxy` to your `Gemfile`. Curently requires HEAD of `em-proxy` because of [this pull request](https://github.com/igrigorik/em-proxy/pull/31).

``` ruby
gem "heroku-forward", :git => "https://github.com/dblock/heroku-forward.git"
gem "em-proxy", :git => "https://github.com/igrigorik/em-proxy.git"
```

Create an application rackup file, eg. `my_app.ru` that boots your application. Under Rails, this is the file that calls `run`.

``` ruby
require ::File.expand_path('../config/environment',  __FILE__)
run MyApp::Application
```

Modify your rackup file as follows. Under Rails this file is called `config.ru`.

``` ruby
require 'rubygems'
require 'bundler'

$stdout.sync = true
Bundler.require(:rack)

port = (ARGV.first || ENV['PORT'] || 3000).to_i
env = ENV['RACK_ENV'] || 'development'

require 'em-proxy'
require 'logger'
require 'heroku-forward'

application = File.expand_path('../my_app.ru', __FILE__)
backend = Heroku::Forward::Backends::Thin.new(application: application, env: env)
proxy = Heroku::Forward::Proxy::Server.new(backend, { host: '0.0.0.0', port: port })
proxy.logger = Logger.new(STDOUT)
proxy.forward!
```

This sets up a proxy on the port requested by Heroku and runs your application with Thin.

Foreman
-------

Heroku Cedar expects a `Procfile` that defines your application processes.

```
web: bundle exec ruby config.ru
worker: bundle exec rake jobs:work
```

You can use `foreman` to test the proxy locally with `foreman start web`.

Heroku Log
----------

Here's the log output from an application that uses this gem. Notice that Heroku reports the state of `web.1` up after just 4 seconds, while the application takes 67 seconds to boot.

```
2012-12-11T23:33:42+00:00 heroku[web.1]: Starting process with command `bundle exec ruby config.ru`
2012-12-11T23:33:46+00:00 app[web.1]:  INFO -- : Launching Backend ...
2012-12-11T23:33:46+00:00 app[web.1]:  INFO -- : Launching Proxy Server at 0.0.0.0:42017 ...
2012-12-11T23:33:46+00:00 app[web.1]: DEBUG -- : Attempting to connect to /tmp/thin20121211-2-1bfazzx.
2012-12-11T23:33:46+00:00 app[web.1]:  WARN -- : no connection, 10 retries left.
2012-12-11T23:33:46+00:00 heroku[web.1]: State changed from starting to up
2012-12-11T23:34:32+00:00 app[web.1]: >> Thin web server (v1.5.0 codename Knife)
2012-12-11T23:34:32+00:00 app[web.1]: >> Maximum connections set to 1024
2012-12-11T23:34:32+00:00 app[web.1]: >> Listening on /tmp/thin20121211-2-1bfazzx, CTRL+C to stop
2012-12-11T23:34:53+00:00 app[web.1]: DEBUG -- : Attempting to connect to /tmp/thin20121211-2-1bfazzx.
2012-12-11T23:34:53+00:00 app[web.1]: DEBUG -- : Proxy Server ready at 0.0.0.0:42017 (67s).
```

Fail-Safe
---------

If you're worried about this implementation, consider building a fail-safe. Modify your `config.ru` to run without a proxy if `DISABLE_FORWARD_PROXY` is set as demonstrated in [this gist](https://gist.github.com/4263488). Add `DISABLE_FORWARD_PROXY` via `heroku config:add DISABLE_FORWARD_PROXY=1`.

Reading Materials
-----------------

* [Heroku R10 Boot Timeout](https://devcenter.heroku.com/articles/error-codes#r10-boot-timeout)
* [Beating Heroku's 60s Boot Times with the Cedar Stack and a Reverse Proxy](http://noverloop.be/beating-herokus-60s-boot-times-with-the-cedar-stack-and-a-reverse-proxy/) by Nicolas Overloop
* [Fighting the Unicorns: Becoming a Thin Wizard on Heroku](http://jgwmaxwell.com/fighting-the-unicorns-becoming-a-thin-wizard-on-heroku/) by JGW Maxwell
* [eventmachine](https://github.com/eventmachine/eventmachine)
* [em-proxy](https://github.com/igrigorik/em-proxy)

Contributing
------------

Fork the project. Make your feature addition or bug fix with tests. Send a pull request. Bonus points for topic branches.

Copyright and License
---------------------

MIT License, see [LICENSE](http://github.com/dblock/heroku-forward/raw/master/LICENSE.md) for details.

(c) 2012 [Daniel Doubrovkine](http://github.com/dblock), [Art.sy](http://artsy.github.com)
