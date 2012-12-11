Heroku::Foward [![Build Status](http://travis-ci.org/dblock/heroku-forward.png)](http://travis-ci.org/dblock/heroku-forward)
==============

Beat Heroku's 60 seconds timeout with a forward proxy.

What's this?
------------

Heroku will report an application crashing and yield an `R10 Boot Timeout` error when a web process took longer than 60 seconds to bind to its assigned `$PORT`. This error is often caused by a process being unable to reach an external resource, such as a database or because Heroku is pretty slow and you have a lot of gems in your `Gemfile`.

This gem implements a forward proxy. The proxy is booted almost immediately, binding to the port assigned by Heroku. It then spawns your application's web server and establishes a connection over a unix domain socket (a file) between the proxy and the application. Once the application is up, it will be able to serve HTTP requests normally. Until then requests may queue and timeout.

Usage
-----

Add `heroku-forward` and `em-proxy` to your `Gemfile`. Curently requires HEAD of `em-proxy` because of [this pull request](https://github.com/igrigorik/em-proxy/pull/31).

``` ruby
gem "heroku-forward"
gem "em-proxy", :git => "https://github.com/igrigorik/em-proxy.git"
```

WIP

Sources
-------

* [Heroky R10 Boot Timeout](https://devcenter.heroku.com/articles/error-codes#r10-boot-timeout)
* [Beating Heroku's 60s Boot Times with the Cedar Stack and a Reverse Proxy](http://noverloop.be/beating-herokus-60s-boot-times-with-the-cedar-stack-and-a-reverse-proxy/) by Nicolas Overloop
* [Fighting the Unicorns: Becoming a Thin Wizard on Heroku](http://jgwmaxwell.com/fighting-the-unicorns-becoming-a-thin-wizard-on-heroku/) by JGW Maxwell

Contributing
------------

Fork the project. Make your feature addition or bug fix with tests. Send a pull request. Bonus points for topic branches.

Copyright and License
---------------------

MIT License, see [LICENSE](http://github.com/dblock/heroku-forward/raw/master/LICENSE.md) for details.

(c) 2012 [Daniel Doubrovkine](http://github.com/dblock), [Art.sy](http://art.sy)
