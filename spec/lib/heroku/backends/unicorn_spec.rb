require 'spec_helper'
require 'heroku/forward/backends/unicorn'

describe Heroku::Forward::Backends::Unicorn do

  let(:backend) do
    Heroku::Forward::Backends::Unicorn.new
  end

  it "#spawned?" do
    backend.spawned?.should be_false
  end

  context "checks" do
    it "checks for application" do
      expect {
        backend.spawn!
      }.to raise_error Heroku::Forward::Errors::MissingBackendOptionError
    end

    it "checks that the application file exists" do
      expect {
        backend.application = 'spec/foobar'
        backend.spawn!
      }.to raise_error Heroku::Forward::Errors::MissingBackendApplicationError
    end

  end

  it "#spawn!" do
    backend.application = "spec/support/app.ru"
    backend.spawn!.should_not == 0
    sleep 2
    backend.terminate!.should be_true
  end
  
  context "constructs command" do
    
    let(:backend) do
      Heroku::Forward::Backends::Unicorn.new(
        :application => 'spec/support/app.ru',
        :env => 'test',
        :socket => '/tmp/unicorn.sock',
        :config_file => 'spec/support/unicorn.rb'
      )
    end

    it "forwards arguments to spawner" do
      Spoon.should_receive(:spawnp).with(*%w{unicorn --env test --config-file spec/support/unicorn.rb --listen /tmp/unicorn.sock spec/support/app.ru}).and_return(0)
      backend.spawn!
    end

  end
end

