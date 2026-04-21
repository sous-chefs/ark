require 'spec_helper'

describe_recipe 'ark::default' do
  platform 'ubuntu'

  it 'delegates prerequisite installation to the custom resource' do
    expect(chef_run).to install_ark_prereq('default')
  end
end
