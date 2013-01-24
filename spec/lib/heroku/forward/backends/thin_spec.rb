require 'spec_helper'
require 'heroku/forward/backends/thin'

describe Heroku::Forward::Backends::Thin do

  describe "without ssl" do
    let(:backend) do
      Heroku::Forward::Backends::Thin.new
    end
    
    after do
      backend.terminate!
    end

    it "#spawned?" do
      backend.spawned?.should be_false
    end
    
    it "doesn't generate socket file" do
      File.exists?(backend.socket).should_not be_true
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
    
    describe "#spawn!" do
      before do
        backend.application = "spec/support/app.ru"
      end
      
      it "starts successfully" do
        backend.spawn!.should_not == 0
        sleep 2
        backend.terminate!.should be_true
      end
      
      it "generates socket file that outlives garbage-collection" do
        backend.spawn!
        sleep 2
        lambda { GC.start }.should_not raise_error
        File.exists?(backend.socket).should be_true
      end
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

