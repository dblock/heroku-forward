require 'heroku/forward/backends/base'

module Heroku
  module Forward
    module Backends
      class Thin < Base
        attr_accessor :ssl
        attr_accessor :ssl_key_file
        attr_accessor :ssl_cert_file
        attr_accessor :ssl_verify

        # options:
        #  application:   passed with     -R, eg. app.ru
        #  socket:        passed with     --socket, eg. /tmp/thin.sock
        #  env:           passed with     -e, defaults to 'development'
        #  ssl:           activated with  --ssl
        #  ssl_key_file:  passed with     ssl_key_file PATH
        #  ssl_cert_file: passed with     ssl_cert_file PATH
        #  ssl_verify:    activated with  ssl_verify
        def initialize(options = {})
          @application = options[:application]
          @socket = options[:socket] || Heroku::Forward::Utils::Dir.tmp_filename('thin-', '.sock')
          @env = options[:env] || :development

          @ssl = options[:ssl] || false
          @ssl_key_file = options[:ssl_key_file] || false
          @ssl_cert_file = options[:ssl_cert_file] || false
          @ssl_verify = options[:ssl_verify] || false
        end

        def spawn!
          return false if spawned?
          check!

          spawn_with = [ "thin" ]
          spawn_with.push "start"
          spawn_with.push "-R", @application
          spawn_with.push "--socket", @socket
          spawn_with.push "-e", @env.to_s
          spawn_with.push "--ssl" if @ssl
          spawn_with.push "--ssl-key-file", @ssl_key_file if @ssl_key_file
          spawn_with.push "--ssl-cert-file", @ssl_cert_file if @ssl_cert_file
          spawn_with.push "--ssl-verify" if @ssl_verify

          @pid = Spoon.spawnp(* spawn_with)
          @spawned = true
        end
      end
    end
  end
end
