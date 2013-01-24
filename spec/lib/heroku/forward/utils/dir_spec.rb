require 'spec_helper'

describe Heroku::Forward::Utils::Dir do
  
  context "#tmp_filename" do
    let(:filename) { Heroku::Forward::Utils::Dir.tmp_filename('foo', '.bar') }
    
    it "doesn't create file" do
      File.exists?(filename).should_not be_true
    end
    
    it "names file using prefix and suffix" do
      filename.should match(/foo.*\.bar/)
    end
  end
  
end

