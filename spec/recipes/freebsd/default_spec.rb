require 'spec_helper'

describe_recipe 'ark::default' do
  def node_attributes
    { platform: 'freebsd', version: '10.3' }
  end

  it 'installs core packages' do
    expect(chef_run).to install_package(%w(libtool autoconf unzip rsync gcc autogen gtar gmake))
  end
end
