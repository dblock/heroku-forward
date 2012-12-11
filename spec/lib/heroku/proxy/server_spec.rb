require 'spec_helper'

describe Heroku::Forward::Proxy::Server do

  let(:backend) do
    Heroku::Forward::Backends::Thin.new({ :application => "spec/support/app.ru" })
  end

  let(:server) do
    Heroku::Forward::Proxy::Server.new(backend, { :host => '127.0.0.1', :port => 4242 })
  end

  context "spawned backend" do

    before :each do
      server.logger = Logger.new(STDOUT)
    end

    after :each do
      backend.terminate!
    end

    it "proxy!" do
      connected = false
      EM.run do
        EventMachine.add_timer(1) do
          EventMachine::HttpRequest.new('http://127.0.0.1:4242/').get({ :timeout => 1 })
        end
        server.on_connect do
          connected = true
          server.stop!
        end
        server.forward!
      end
    end
  end

end

