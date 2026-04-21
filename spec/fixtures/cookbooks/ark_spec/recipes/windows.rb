include_recipe 'ark'

fixture_root = ::File.join(run_context.cookbook_collection['ark'].root_dir, 'files', 'default')

group 'foobar'

user 'foobarbaz' do
  group 'foobarbaz'
end

ark 'foo' do
  url "file://#{fixture_root}/foo.tar.gz"
  checksum '5996e676f17457c823d86f1605eaa44ca8a81e70d6a0e5f8e45b51e62e0c52e8'
  version '2'
  win_install_dir 'C:\dir'
  owner 'foobarbaz'
  group 'foobar'
  has_binaries ['bin\do_foo', 'bin\do_more_foo']
  action :install
end
