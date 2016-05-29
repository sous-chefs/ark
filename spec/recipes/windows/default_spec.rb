require 'spec_helper'

describe_recipe 'ark::default' do
  def node_attributes
    { platform: 'windows', version: '2012R2' }
  end

  let(:expected_packages) do
    %w( libtool autoconf unzip rsync make gcc autogen xz-lzma-compat )
  end
  
  let(:fake_hkey_local_machine) do
    fake_hkey_local_machine = double('fake_hkey_local_machine') 
    seven_zip_win32_registry = double('seven_zip_registry')
    allow(seven_zip_win32_registry).to receive(:read_s).with('Path').and_return('C:\\Program Files\\7-Zip')
    allow(fake_hkey_local_machine).to receive(:open).with('SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\7zFM.exe', ::Win32::Registry::KEY_READ).and_return(seven_zip_win32_registry)
    fake_hkey_local_machine
  end

  before(:each) do
    if not defined? ::Win32 
      module Win32
        class Registry
        end
      end
    end
    stub_const("::Win32::Registry::KEY_READ", double('win32_registry_key_read'))
    stub_const("::Win32::Registry::HKEY_LOCAL_MACHINE", fake_hkey_local_machine)
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
