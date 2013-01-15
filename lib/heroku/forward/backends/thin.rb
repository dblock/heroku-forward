module Heroku
  module Forward
    module Backends
      class Thin
        include POSIX::Spawn

        attr_accessor :application
        attr_accessor :socket
        attr_accessor :environment
        attr_accessor :pid

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
          @socket = options[:socket] || new_socket
          @env = options[:env] || :development

          @ssl = options[:ssl] || false
          @ssl_key_file = options[:ssl_key_file] || false
          @ssl_cert_file = options[:ssl_cert_file] || false
          @ssl_verify = options[:ssl_verify] || false
        end

        def spawn!
          return false if spawned?
          check!

          spawn_with = "thin start -R #{@application} --socket #{@socket} -e #{@env}"
          spawn_with << " --ssl" if @ssl
          spawn_with << " --ssl-key-file #{@ssl_key_file}" if @ssl_key_file
          spawn_with << " --ssl-cert-file #{@ssl_cert_file}" if @ssl_cert_file
          spawn_with << " --ssl-verify" if @ssl_verify

          @pid = spawn(spawn_with)
          @spawned = true
        end

        def terminate!
          return false unless spawned?
          Process.kill 'QUIT', @pid
          @spawned = false
          true
        end

        def spawned?
          !! @spawned
        end

        private

          def new_socket
            Tempfile.open 'thin' do |file|
              return file.path
            end
          end

          def check!
            raise Heroku::Forward::Errors::MissingBackendOptionError.new('application') unless @application && @application.length > 0
            raise Heroku::Forward::Errors::MissingBackendApplicationError.new(@application) unless File.exists?(@application)
          end

      end
    end
  end
end
