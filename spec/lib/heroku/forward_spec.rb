require 'spec_helper'

describe Heroku::Forward do
  it "has a version" do
    Heroku::Forward::VERSION.should_not be_nil
  end
end

