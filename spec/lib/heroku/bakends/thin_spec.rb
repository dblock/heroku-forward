require 'spec_helper'

describe Heroku::Forward::Backends::Thin do

  describe "without ssl" do
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

  describe "with SSL" do
    let(:application) { "spec/support/app.ru" }
    let(:mock_ssl_cert_file) { "foo" }
    let(:mock_ssl_key_file) { "bar" }
    let(:socket) { "foobar" }

    let(:backend) do
      Heroku::Forward::Backends::Thin.new({
        :application => application,
        :socket => socket,
        :ssl => true,
        :ssl_verify => true,
        :ssl_key_file => mock_ssl_key_file,
        :ssl_cert_file => mock_ssl_cert_file
      })
    end

    it "forward SSL arguments on spawning" do
      cmd = []
      cmd.push "thin"
      cmd.push "start"
      cmd.push "-R", application
      cmd.push "--socket", socket
      cmd.push "-e", "development"
      cmd.push "--ssl"
      cmd.push "--ssl-key-file", mock_ssl_key_file
      cmd.push "--ssl-cert-file", mock_ssl_cert_file
      cmd.push "--ssl-verify"
      Spoon.should_receive(:spawnp).with(* cmd).and_return(0)
      backend.spawn!
    end

  end
end

