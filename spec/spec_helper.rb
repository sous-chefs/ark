require 'chefspec'
require 'chefspec/berkshelf'

at_exit { ChefSpec::Coverage.report! }

RSpec.configure do |config|
  config.color = true
  config.alias_example_group_to :describe_recipe, :type => :recipe
end

RSpec.shared_context "recipe tests", :type => :recipe do

  let(:chef_run) { ChefSpec::Runner.new(node_properties).converge(described_recipe) }

  let(:node) { chef_run.node }

  def node_properties
    {}
  end

  def cookbook_recipe_names
    described_recipe.split("::",2)
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