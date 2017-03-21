require "spec_helper"

RSpec.describe Itunes::Receipt do
  it "has a version number" do
    expect(Itunes::Receipt::VERSION).not_to be nil
  end
end
