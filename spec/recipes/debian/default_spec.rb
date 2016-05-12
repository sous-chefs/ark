require 'spec_helper'

describe_recipe 'ark::default' do
  def node_attributes
    { platform: 'ubuntu', platform_family: 'debian', version: '14.04' }
  end

  let(:expected_packages) do
    %w( libtool autoconf unzip rsync make gcc shtool pkg-config )
  end

  it 'installs core packages' do
    expected_packages.each do |package|
      expect(chef_run).to install_package(package)
    end
  end
end
