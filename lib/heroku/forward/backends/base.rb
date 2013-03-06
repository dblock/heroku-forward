module Heroku
  module Forward
    module Backends
      class Base
        attr_accessor :application, :socket, :environment, :pid

        def terminate!
          return false unless spawned?
          Process.kill 'QUIT', @pid
          @spawned = false
          true
        end

        def spawned?
          !!@spawned
        end

        private

        def check!
          raise Heroku::Forward::Errors::MissingBackendOptionError.new('application') unless @application && @application.length > 0
          raise Heroku::Forward::Errors::MissingBackendApplicationError.new(@application) unless File.exists?(@application)
        end
      end
    end
  end
end
