$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'heroku-forward'
require 'em-proxy'
require 'em-http'
require 'logger'
require 'mocha'

require 'support/em_server'
