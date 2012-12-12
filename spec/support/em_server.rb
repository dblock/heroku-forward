module EM
  module Server
    def run(server, &block)
      connected = false
      EM.run do
        EventMachine.add_timer(1) do
          EventMachine::HttpRequest.new('http://127.0.0.1:4242/').get({ :timeout => 1 })
        end
        server.on_connect do
          connected = true
          server.stop!
        end
        yield
      end
    end
    module_function :run
  end
end

