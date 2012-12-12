require 'i18n'
require 'tempfile'
require 'em-proxy'
require 'posix/spawn'

I18n.load_path << File.join(File.dirname(__FILE__), "heroku", "forward", "config", "locales", "en.yml")

require 'heroku/forward'


