require 'spec_helper'
require 'heroku/forward/backends/thin'

describe Heroku::Forward::Backends::Thin do
  describe 'without ssl' do
    let(:backend) do
      Heroku::Forward::Backends::Thin.new
    end

    after do
      backend.terminate!
    end

    it '#spawned?' do
      expect(backend.spawned?).to be false
    end

    it "doesn't generate socket file" do
      expect(File.exist?(backend.socket)).not_to be true
    end

    context 'checks' do
      it 'checks for application' do
        expect do
          backend.spawn!
        end.to raise_error Heroku::Forward::Errors::MissingBackendOptionError
      end

      it 'checks that the application file exists' do
        expect do
          backend.application = 'spec/foobar'
          backend.spawn!
        end.to raise_error Heroku::Forward::Errors::MissingBackendApplicationError
      end
    end

    describe '#spawn!' do
      before do
        backend.application = 'spec/support/app.ru'
      end

      it 'starts successfully' do
        expect(backend.spawn!).not_to eq(0)
        sleep 2
        expect(backend.terminate!).to be true
      end

      it 'generates socket file that outlives garbage-collection' do
        backend.spawn!
        sleep 2
        expect { GC.start }.not_to raise_error
        expect(File.exist?(backend.socket)).to be true
      end
    end
  end

  describe 'with SSL' do
    let(:application) { 'spec/support/app.ru' }
    let(:mock_ssl_cert_file) { 'foo' }
    let(:mock_ssl_key_file) { 'bar' }
    let(:socket) { 'foobar' }

    let(:backend) do
      Heroku::Forward::Backends::Thin.new(application: application,
                                          socket: socket,
                                          ssl: true,
                                          ssl_verify: true,
                                          ssl_key_file: mock_ssl_key_file,
                                          ssl_cert_file: mock_ssl_cert_file)
    end

    it 'forward SSL arguments on spawning' do
      cmd = []
      cmd.push 'thin'
      cmd.push 'start'
      cmd.push '-R', application
      cmd.push '--socket', socket
      cmd.push '-e', 'development'
      cmd.push '--ssl'
      cmd.push '--ssl-key-file', mock_ssl_key_file
      cmd.push '--ssl-cert-file', mock_ssl_cert_file
      cmd.push '--ssl-verify'
      expect(Spoon).to receive(:spawnp).with(* cmd).and_return(0)
      backend.spawn!
    end
  end
end
