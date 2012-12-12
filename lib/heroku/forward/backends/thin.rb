module Heroku
  module Forward
    module Backends
      class Thin
        include POSIX::Spawn

        attr_accessor :application
        attr_accessor :socket
        attr_accessor :environment
        attr_accessor :pid

        # options:
        #  application: passed with -R, eg. app.ru
        #  socket: passed with --socket, eg. /tmp/thin.sock
        #  env: passed with -e, defaults to 'development'
        def initialize(options = {})
          @application = options[:application]
          @socket = options[:socket] || new_socket
          @env = options[:env] || :development
        end

        def spawn!
          return false if spawned?
          check!
          @pid = spawn("thin start -R #{@application} --socket #{@socket} -e #{@env}")
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
