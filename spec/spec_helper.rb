require 'chefspec'
require 'chefspec/berkshelf'

at_exit { ChefSpec::Coverage.report! }

RSpec.configure do |config|
  config.color = true
  config.alias_example_group_to :describe_recipe, :type => :recipe
  config.alias_example_group_to :describe_helpers, :type => :helpers
end

def stringify_keys(hash)
  hash.inject({}) do |base, (k, v)|
    v = stringify_keys(v) if v.is_a? Hash
    base[k.to_s] = v
    base
  end
end

RSpec.shared_context "recipe tests", :type => :recipe do

  let(:chef_run) { ChefSpec::Runner.new(node_properties).converge(described_recipe) }

  let(:node) { chef_run.node }

  def node_properties
    {}
  end

  def cookbook_recipe_names
    described_recipe.split("::", 2)
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

RSpec.shared_context "helpers tests", :type => :helpers do
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
