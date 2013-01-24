module Heroku
  module Forward
    module Backends
      class Unicorn
        attr_accessor :application, :socket, :environment, :pid, :config_file
        
        def initialize(options = {})
          @application = options[:application]
          @socket = options[:socket] || Heroku::Forward::Utils::Dir.tmp_filename('unicorn', '.sock')
          @env = options[:env] || 'development'
          @config_file = options[:config_file]
        end
        
        def spawn!
          return false if spawned?
          check!
          
          args = ['unicorn']
          args.push '--env', @env
          args.push '--config-file', @config_file if @config_file
          args.push '--listen', @socket
          args.push @application
          
          @pid = Spoon.spawnp(*args)
          @spawned = true
        end
        
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
