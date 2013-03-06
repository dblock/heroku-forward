require 'heroku/forward/backends/base'

module Heroku
  module Forward
    module Backends
      class Unicorn < Base
        attr_accessor :config_file

        def initialize(options = {})
          @application = options[:application]
          @socket = options[:socket] || Heroku::Forward::Utils::Dir.tmp_filename('unicorn-', '.sock')
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
      end
    end
  end
end
