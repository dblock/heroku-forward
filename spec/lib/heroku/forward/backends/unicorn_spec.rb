require 'spec_helper'
require 'heroku/forward/backends/unicorn'

describe Heroku::Forward::Backends::Unicorn do
  describe 'with defaults' do
    let(:backend) do
      Heroku::Forward::Backends::Unicorn.new
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
      Heroku::Forward::Backends::Unicorn.new(
        application: 'spec/support/app.ru',
        env: 'test',
        socket: '/tmp/unicorn.sock',
        config_file: 'spec/support/unicorn.rb'
      )
    end

    it 'forwards arguments to spawner' do
      expect(Spoon).to receive(:spawnp).with(*%w(unicorn --env test --config-file spec/support/unicorn.rb --listen /tmp/unicorn.sock spec/support/app.ru)).and_return(0)
      backend.spawn!
    end
  end
end
