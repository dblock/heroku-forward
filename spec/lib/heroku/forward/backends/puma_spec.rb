require 'spec_helper'
require 'heroku/forward/backends/puma'

describe Heroku::Forward::Backends::Puma do
  describe 'with defaults' do
    let(:backend) do
      Heroku::Forward::Backends::Puma.new
    end

    after do
      backend.terminate!
    end

    it '#spawned?' do
      expect(backend.spawned?).to be false
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

    it '#spawn!' do
      backend.application = 'spec/support/app.ru'
      expect(backend.spawn!).not_to eq(0)
      sleep 2
      expect(backend.terminate!).to be true
    end
  end

  context 'constructs command' do
    let(:backend) do
      Heroku::Forward::Backends::Puma.new(
        application: 'spec/support/app.ru',
        env: 'test',
        socket: '/tmp/puma.sock',
        config_file: 'spec/support/puma.rb'
      )
    end

    it 'forwards arguments to spawner' do
      expect(Spoon).to receive(:spawnp).with(*%w(puma --environment test --config spec/support/puma.rb --bind unix:///tmp/puma.sock spec/support/app.ru)).and_return(0)
      backend.spawn!
    end
  end
end
