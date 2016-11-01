require 'spec_helper'

describe_recipe 'ark::default' do
  include_context 'seven zip installed'

  def node_attributes
    { platform: 'windows', version: '2012R2' }
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
