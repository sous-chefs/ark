require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
  config.alias_example_group_to :describe_recipe, type: :recipe
  config.alias_example_group_to :describe_helpers, type: :helpers
  config.alias_example_group_to :describe_resource, type: :resource
  config.file_cache_path = '/var/chef/cache'
  config.log_level = :fatal
  config.platform = 'ubuntu'
end

def stringify_keys(hash)
  hash.each_with_object({}) do |(k, v), base|
    v = stringify_keys(v) if v.is_a? Hash
    base[k.to_s] = v
    base
  end
end

RSpec.shared_context 'recipe tests', type: :recipe do
  let(:chef_run) { ChefSpec::SoloRunner.new(node_attributes).converge(described_recipe) }

  let(:node) { chef_run.node }

  def node_attributes
    {}
  end

  def cookbook_recipe_names
    described_recipe.split('::', 2)
  end

  def cookbook_name
    cookbook_recipe_names.first
  end

  def recipe_name
    cookbook_recipe_names.last
  end

  def default_cookbook_attribute(attribute_name)
    node[cookbook_name][attribute_name]
  end
end

RSpec.shared_context 'helpers tests', type: :helpers do
  include described_class

  let(:new_resource) { OpenStruct.new(resource_properties) }

  def resource_properties
    @resource_properties || {}
  end

  def with_resource_properties(properties)
    @resource_properties = properties
  end

  let(:node) do
    Fauxhai.mock { |node| node.merge!(node_attributes) }.data
  end

  def node_attributes
    stringify_keys(@node_attributes || {})
  end

  def with_node_attributes(attributes)
    @node_attributes = attributes
  end
end

RSpec.shared_context 'resource tests', type: :resource do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(node_attributes.merge(step_into)).converge(example_recipe)
  end

  let(:example_recipe) do
    raise %(
Please specify the name of the test recipe that executes your recipe:

    let(:example_recipe) do
      "ark_spec::put"
    end

)
  end

  let(:node) { chef_run.node }

  def node_attributes
    {}
  end

  let(:step_into) do
    { step_into: [cookbook_name] }
  end

  def cookbook_recipe_names
    described_recipe.split('::', 2)
  end

  def cookbook_name
    cookbook_recipe_names.first
  end

  def recipe_name
    cookbook_recipe_names.last
  end
end

shared_context 'seven zip installed' do
  let(:fake_hkey_local_machine) do
    fake_hkey_local_machine = double('fake_hkey_local_machine')
    seven_zip_win32_registry = double('seven_zip_registry')
    allow(seven_zip_win32_registry).to receive(:read_s).with('Path').and_return('C:\\Program Files\\7-Zip')
    allow(fake_hkey_local_machine).to receive(:open).with('SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\7zFM.exe').and_return(seven_zip_win32_registry)
    fake_hkey_local_machine
  end

  before(:each) do
    unless defined? ::Win32
      module Win32
        class Registry
        end
      end
    end
    stub_const('::Win32::Registry::HKEY_LOCAL_MACHINE', fake_hkey_local_machine)
    stub_const('::Win32::Registry::Error', double('win32_registry_error')) unless defined? ::Win32::Registry::Error
  end
end
