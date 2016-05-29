require 'spec_helper'

describe_recipe 'ark::default' do
  include_context 'seven zip installed'

  def node_attributes
    { platform: 'windows', version: '2012R2' }
  end

  let(:expected_packages) do
    %w( libtool autoconf unzip rsync make gcc autogen xz-lzma-compat )
  end

  it 'does not installs packages' do
    expected_packages.each do |package|
      expect(chef_run).not_to install_package(package)
    end
  end

  it 'does include the 7-zip recipe' do
    expect(chef_run).to include_recipe('seven_zip')
  end

  context 'sets default attributes' do
    it 'tar binary' do
      expect(default_cookbook_attribute('tar')).to eq %("C:\\Program Files\\7-Zip\\7z.exe")
    end
  end
end
