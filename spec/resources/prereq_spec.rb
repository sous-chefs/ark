require 'spec_helper'

describe_resource 'ark_prereq' do
  let(:example_recipe) { 'ark::default' }

  let(:step_into) do
    { step_into: ['ark_prereq'] }
  end

  context 'on ubuntu' do
    it 'installs the default package dependencies' do
      expect(chef_run).to install_ark_prereq('default')
      expect(chef_run).to install_package('default package dependencies')

      resource = chef_run.package('default package dependencies')
      expect(resource.package_name).to eq(%w(libtool autoconf make unzip rsync gcc autogen bzip2 xz-utils shtool pkg-config))

      expect(chef_run).not_to install_seven_zip_tool('default')
    end
  end

  context 'on windows' do
    def node_attributes
      { platform: 'windows', version: '10' }
    end

    it 'installs 7-Zip instead of package dependencies' do
      expect(chef_run).to install_ark_prereq('default')
      expect(chef_run).to install_seven_zip_tool('default')
      expect(chef_run).not_to install_package('default package dependencies')
    end
  end
end
