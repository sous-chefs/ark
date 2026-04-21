require 'spec_helper'
require './libraries/default'

describe Ark::PlatformDefaults do
  describe '.prefix_root' do
    it 'defaults to /usr/local' do
      expect(described_class.prefix_root).to eq('/usr/local')
    end
  end

  describe '.prefix_bin' do
    it 'defaults to /usr/local/bin' do
      expect(described_class.prefix_bin).to eq('/usr/local/bin')
    end
  end

  describe '.prefix_home' do
    it 'defaults to /usr/local' do
      expect(described_class.prefix_home).to eq('/usr/local')
    end
  end

  describe '.version' do
    it 'defaults to 1' do
      expect(described_class.version).to eq('1')
    end
  end

  describe '.package_dependencies' do
    it 'returns empty dependencies on macOS' do
      node = { 'platform_family' => 'mac_os_x', 'platform' => 'mac_os_x', 'platform_version' => '15.0' }
      expect(described_class.package_dependencies(node)).to eq([])
    end

    it 'returns empty dependencies on windows' do
      node = { 'platform_family' => 'windows', 'platform' => 'windows', 'platform_version' => '10.0' }
      expect(described_class.package_dependencies(node)).to eq([])
    end

    it 'returns Debian dependencies' do
      node = { 'platform_family' => 'debian', 'platform' => 'ubuntu', 'platform_version' => '24.04' }
      expect(described_class.package_dependencies(node)).to eq(%w(libtool autoconf make unzip rsync gcc autogen bzip2 xz-utils shtool pkg-config))
    end

    it 'returns CentOS 6 dependencies' do
      node = { 'platform_family' => 'rhel', 'platform' => 'centos', 'platform_version' => '6.10' }
      expect(described_class.package_dependencies(node)).to eq(%w(libtool autoconf make unzip rsync gcc xz-lzma-compat bzip2 tar))
    end

    it 'returns CentOS 7 dependencies' do
      node = { 'platform_family' => 'rhel', 'platform' => 'centos', 'platform_version' => '7.9' }
      expect(described_class.package_dependencies(node)).to eq(%w(libtool autoconf make unzip rsync gcc xz bzip2 tar))
    end

    it 'returns Fedora dependencies' do
      node = { 'platform_family' => 'fedora', 'platform' => 'fedora', 'platform_version' => '41' }
      expect(described_class.package_dependencies(node)).to eq(%w(libtool autoconf make unzip rsync gcc xz-lzma-compat bzip2 tar))
    end

    it 'returns FreeBSD dependencies' do
      node = { 'platform_family' => 'freebsd', 'platform' => 'freebsd', 'platform_version' => '14.1' }
      expect(described_class.package_dependencies(node)).to eq(%w(libtool autoconf unzip rsync gcc autogen gtar gmake))
    end

    it 'returns openSUSE dependencies' do
      node = { 'platform_family' => 'suse', 'platform' => 'opensuse', 'platform_version' => '15.6' }
      expect(described_class.package_dependencies(node)).to eq(%w(libtool autoconf make unzip rsync gcc xz bzip2 tar))
    end
  end

  describe '.tar_binary' do
    it 'returns the BSD tar path on FreeBSD' do
      node = { 'platform_family' => 'freebsd', 'platform' => 'freebsd' }
      expect(described_class.tar_binary(node)).to eq('/usr/bin/tar')
    end

    it 'returns the GNU tar path on SmartOS' do
      node = { 'platform_family' => 'solaris2', 'platform' => 'smartos' }
      expect(described_class.tar_binary(node)).to eq('/bin/gtar')
    end

    it 'returns the Linux tar path by default' do
      node = { 'platform_family' => 'debian', 'platform' => 'ubuntu' }
      expect(described_class.tar_binary(node)).to eq('/bin/tar')
    end
  end
end
