require 'minitest/spec'

describe_recipe 'ark::test' do

    # It's often convenient to load these includes in a separate
  # helper along with
  # your own helper methods, but here we just include them directly:
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  it "cherrypick the mysql connector and set the correct owner and group" do
    file("/usr/local/foozball/mysql-connector-java-5.1.19-bin.jar").must_exist.with(:owner, "foobarbaz").and(:group, "foobarbaz")
  end

  it "dumps the correct files into place with correct owner and group" do

  end
  
  
  
end
