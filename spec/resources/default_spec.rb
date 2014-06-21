require 'spec_helper'

describe_resource "ark" do

  let(:example_recipe) { "ark_test::put" }


  it "" do
    expect(chef_run).to put_ark("test_put")
    expect(chef_run).to create_directory("/usr/local/test_put")
    resource = chef_run.directory("/usr/local/test_put")
    expect(resource).to notify('execute[unpack /var/chef/cache/test_put.tar.gz]').to(:run)


    expect(chef_run).to create_remote_file("/var/chef/cache/test_put.tar.gz")
    resource = chef_run.remote_file("/var/chef/cache/test_put.tar.gz")
    expect(resource).to notify('execute[unpack /var/chef/cache/test_put.tar.gz]').to(:run)

    expect(chef_run).to put_ark('test_put')

    expect(chef_run).to_not run_execute("unpack /var/chef/cache/test_put.tar.gz")
    expect(chef_run).to_not run_execute("set owner on /usr/local/test_put")
  end

end