require 'spec_helper'
require './libraries/default'

describe Ark::WindowsOwner do

  let(:subject) { described_class.new(resource) }

  let(:resource) { double(path: "c:\\resource with spaces\\path", owner: "the new owner") }

  it "generates the correct command for windows file ownership" do
    expect(subject.command).to eq("icacls \"c:\\resource with spaces\\path\\*\" /setowner \"the new owner\"")
  end

end
