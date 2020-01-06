require 'spec_helper'

describe_recipe 'ark::default' do
  def node_attributes
    { platform: 'debian' }
  end

  it 'installs core packages' do
    expect(chef_run).to install_package(%w(libtool autoconf make unzip rsync gcc autogen shtool pkg-config))
  end
end
