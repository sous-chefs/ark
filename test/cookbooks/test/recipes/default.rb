apt_update 'update' if platform_family?('debian')

fixture_root = ::File.join(run_context.cookbook_collection['ark'].root_dir, 'files', 'default')
fixture_url = "file://#{fixture_root}"

group 'foobarbaz_group'

user 'foobarbaz' do
  group 'foobarbaz_group'
end

directory '/opt/bin' do
  recursive true
end

ark 'foo' do
  url "#{fixture_url}/foo.tar.gz"
  checksum '5996e676f17457c823d86f1605eaa44ca8a81e70d6a0e5f8e45b51e62e0c52e8'
  version '2'
  prefix_root '/usr/local'
  owner 'foobarbaz'
  group 'foobarbaz_group'
  has_binaries ['bin/do_foo', 'bin/do_more_foo']
  action :install
end

ark 'test_put' do
  url "#{fixture_url}/foo.tar.gz"
  checksum '5996e676f17457c823d86f1605eaa44ca8a81e70d6a0e5f8e45b51e62e0c52e8'
  owner 'foobarbaz'
  group 'foobarbaz_group'
  action :put
end

ark 'test_dump' do
  url "#{fixture_url}/foo.zip"
  checksum 'deea3a324115c9ca0f3078362f807250080bf1b27516f7eca9d34aad863a11e0'
  path '/usr/local/foo_dump'
  creates 'foo1.txt'
  owner 'foobarbaz'
  group 'foobarbaz_group'
  action :dump
end

ark 'cherry_pick_test' do
  url "#{fixture_url}/foo.tar.gz"
  checksum '5996e676f17457c823d86f1605eaa44ca8a81e70d6a0e5f8e45b51e62e0c52e8'
  path '/usr/local/foo_cherry_pick'
  owner 'foobarbaz'
  group 'foobarbaz_group'
  creates 'foo_sub/foo1.txt'
  action :cherry_pick
end

ark 'foo_append_env' do
  version '7.0.26'
  url "#{fixture_url}/foo.tar.gz"
  checksum '5996e676f17457c823d86f1605eaa44ca8a81e70d6a0e5f8e45b51e62e0c52e8'
  append_env_path true
  action :install
end

ark 'test_autogen' do
  url "#{fixture_url}/configure_fixture.tar.gz"
  extension 'tar.gz'
  action :configure
end
