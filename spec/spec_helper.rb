$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'heroku-forward'
require 'em-http'
require 'logger'

require 'support/em_server'
