require 'spec_helper'

describe Heroku::Forward::Backends::Thin do

  let(:backend) do
    Heroku::Forward::Backends::Thin.new
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

end

