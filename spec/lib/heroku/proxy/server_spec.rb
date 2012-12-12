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
      EM::Server.run(server) do
        server.forward!
      end
    end

    it "waits for delay seconds" do
      EM::Server.run(server) do
        server.should_receive(:sleep).with(2)
        server.forward!(:delay => 2)
      end
    end

  end

end

