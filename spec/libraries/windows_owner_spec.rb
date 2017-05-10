require 'spec_helper'
require './libraries/default'

describe Ark::WindowsOwner do
  let(:subject) { described_class.new(resource) }

  let(:resource) { double(path: 'c:\\resource with spaces\\path', owner: 'the new owner') }

  before(:each) do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('SystemRoot').and_return('C:\\Windows')
  end

  it 'generates the correct command for windows file ownership' do
    expect(subject.command).to eq('C:\\Windows\\System32\\icacls "c:\\resource with spaces\\path\\*" /setowner "the new owner"')
  end
end
