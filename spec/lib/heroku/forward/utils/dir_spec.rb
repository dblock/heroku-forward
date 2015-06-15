require 'spec_helper'

describe Heroku::Forward::Utils::Dir do
  context '#tmp_filename' do
    let(:filename) { Heroku::Forward::Utils::Dir.tmp_filename('foo', '.bar') }

    it "doesn't create file" do
      expect(File.exist?(filename)).not_to be true
    end

    it 'names file using prefix and suffix' do
      expect(filename).to match(/foo.*\.bar/)
    end
  end
end
