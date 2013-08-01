module Heroku
  module Forward
    module Proxy

      class Server
        attr_reader :host, :port, :backend, :retries, :start
        attr_accessor :logger

        def initialize(backend, options = {})
          @host = options[:host] || '0.0.0.0'
          @port = options[:port] || 3000
          @retries = options[:retries] || 10
          @backend = backend
        end

        def on_connect(&callback)
          if block_given?
            @on_connect = callback
          elsif @on_connect
            @on_connect.call
          end
        end

        def forward!(options = {})

          @start = Time.now

          logger.info "Launching Backend ..." if logger

          backend.spawn!

          if options[:delay] && (delay = options[:delay].to_i) > 0
            logger.info "Waiting #{delay}s to Launch Proxy Server ..." if logger
            sleep delay
          end

          logger.info "Launching Proxy Server at #{host}:#{port} ..." if logger

          s = self
          ::Proxy.start({ :host => host, :port => port, :debug => false }) do |conn|
            if @start
              EM.next_tick do
                s.send(:connect, conn)
              end
            else
              s.send(:connect, conn)
            end

            conn.on_connect do
              s.on_connect
            end

            conn.on_data do |data|
              data
            end

            conn.on_response do |backend, resp|
              resp
            end

            conn.on_finish do
            end
          end

        end

        def stop!
          logger.info "Terminating Proxy Server" if logger
          EventMachine.stop
          logger.info "Terminating Web Server" if logger
          backend.terminate!
        end

        private

          def connect(conn)
            begin
              if start
                logger.debug "Attempting to connect to #{backend.socket}." if logger
              end
              conn.server backend, :socket => backend.socket
              if @start
                logger.debug "Proxy Server ready at #{host}:#{port} (#{(Time.now - start).to_i}s)." if logger
                @start = nil
              end
            rescue RuntimeError => e
              raise Heroku::Forward::Errors::BackendFailedToStartError.new if @retries <= 0
              logger.warn "#{e.message}, #{retries} #{retries == 1 ? 'retry' : 'retries'} left." if logger
              @retries -= 1
            end
          end

      end
    end
  end
end
