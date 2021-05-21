require 'spec_helper'

describe_recipe 'ark::default' do
  def node_attributes
    { platform: 'windows' }
  end

  it do
    expect(chef_run).to install_seven_zip_tool 'ark'
  end
end
