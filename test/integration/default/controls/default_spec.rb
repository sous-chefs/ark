# frozen_string_literal: true

title 'ark default integration tests'

control 'ark-install-01' do
  impact 1.0
  title 'Archive install action extracts and links binaries'

  describe directory('/usr/local/foo-2') do
    it { should exist }
  end

  describe file('/usr/local/foo-2/foo1.txt') do
    it { should exist }
  end

  describe file('/usr/local/foo') do
    it { should be_symlink }
  end

  describe file('/usr/local/bin/do_foo') do
    it { should be_symlink }
  end
end

control 'ark-extract-01' do
  impact 1.0
  title 'Alternate extraction actions create expected files'

  describe file('/usr/local/test_put/foo1.txt') do
    it { should exist }
  end

  describe file('/usr/local/foo_dump/foo1.txt') do
    it { should exist }
  end

  describe file('/usr/local/foo_cherry_pick/foo1.txt') do
    it { should exist }
  end
end

control 'ark-configure-01' do
  impact 0.7
  title 'Configure and PATH helper artifacts are created'

  describe file('/usr/local/test_autogen-1/configure') do
    it { should exist }
  end

  describe file('/etc/profile.d/foo_append_env.sh') do
    it { should exist }
  end
end
