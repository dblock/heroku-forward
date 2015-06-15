Next release
============

* [#19](https://github.com/dblock/heroku-forward/pull/19) - Send TERM rather than QUIT to Puma cluster - [@mjtko](https://github.com/mjtko).
* [#19](https://github.com/dblock/heroku-forward/pull/19) - Added configuration of termination signal for Puma - [@mjtko](https://github.com/mjtko).

0.4.0 (8/1/2013)
================

* [#13](https://github.com/dblock/heroku-forward/pull/13) - Add support for Puma back-end - [@filiptepper](https://github.com/filiptepper).
* [#14](https://github.com/dblock/heroku-forward/issues/14) - Fix: uninitialized constant `Heroku::Forward::Proxy::Server::BackendFailedToStartError` on server start failure - [@joeyAghion](https://github.com/joeyAghion).

0.3.1 (1/25/2013)
=================

* [#6](https://github.com/dblock/heroku-forward/pull/6) - Fix: socket file gets deleted on garbage-collection - [@joeyAghion](https://github.com/joeyAghion).

0.3.0 (1/24/2013)
=================

* [#5](https://github.com/dblock/heroku-forward/pull/5) - Add support for Unicorn back-end - [@joeyAghion](https://github.com/joeyAghion).
* Fix: `--ssl-key-file` option causes a `thin/controllers/controller.rb:37:in 'start': wrong number of arguments (2 for 0)` error - [@dblock](https://github.com/dblock).

0.2.0 (01/15/2013)
==================

* Added support for Thin's SSL options - [@mfo](https://github.com/mfo).
* Replaced [posix-spawn](https://github.com/rtomayko/posix-spawn) with libffi-based more portable [spoon](https://github.com/headius/spoon) - [@dblock](https://github.com/dblock).

0.1.0 (12/13/2012)
==================

* Initial public release with back-end support for Thin - [@dblock](https://github.com/dblock).

