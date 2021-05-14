require 'spec_helper'

describe_recipe 'ark::default' do
  def node_attributes
    { platform: 'freebsd' }
  end

  it 'installs core packages' do
    expect(chef_run).to install_package(%w(libtool autoconf unzip rsync gcc autogen gtar gmake))
  end
end
