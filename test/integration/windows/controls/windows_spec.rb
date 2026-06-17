# frozen_string_literal: true

title 'ark Windows integration tests'

control 'ark-windows-install-01' do
  impact 1.0
  title 'Archive install action extracts local file URLs on Windows'

  describe directory('C:/dir') do
    it { should exist }
  end

  describe file('C:/dir/foo1.txt') do
    it { should exist }
  end

  describe file('C:/dir/bin/do_foo') do
    it { should exist }
  end
end
