require 'spec_helper'
require 'heroku/forward/backends/thin'
require 'heroku/forward/backends/unicorn'
require 'heroku/forward/backends/puma'

describe Heroku::Forward::Proxy::Server do
  [
    Heroku::Forward::Backends::Thin,
    Heroku::Forward::Backends::Unicorn,
    Heroku::Forward::Backends::Puma
  ].each do |backend_type|
    context "with #{backend_type.name} backend" do
      let(:backend) do
        backend_type.new(application: 'spec/support/app.ru')
      end

      let(:server) do
        Heroku::Forward::Proxy::Server.new(backend, host: '127.0.0.1', port: 4242, retries: 0)
      end

      before :each do
        server.logger = Logger.new(STDOUT)
      end

      after :each do
        backend.terminate!
      end

      context 'forwarding' do
        it 'proxy!' do
          EM::Server.run(server) do
            server.forward!
          end
        end

        it 'waits for delay seconds' do
          EM::Server.run(server) do
            expect(server).to receive(:sleep).with(2)
            server.forward!(delay: 2)
          end
        end
      end

      it 'fails' do
        allow_any_instance_of(EM::ProxyServer::Connection).to receive(:server) { fail 'Whoops' }
        expect do
          EM::Server.run(server) { server.forward! }
        end.to raise_error(Heroku::Forward::Errors::BackendFailedToStartError)
      end
    end
  end
end
