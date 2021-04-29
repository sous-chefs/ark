require 'spec_helper'

describe_recipe 'ark::default' do
  platform 'ubuntu'

  it 'installs core packages' do
    expect(chef_run).to install_package(%w(libtool autoconf make unzip rsync gcc autogen shtool pkg-config))
  end

  it 'does not install the gcc-c++ package' do
    expect(chef_run).not_to install_package('gcc-c++')
  end

  it 'does not include the seven_zip recipe' do
    expect(chef_run).not_to include_recipe('seven_zip')
  end
end
