fixture_root = ::File.join(run_context.cookbook_collection['ark'].root_dir, 'files', 'default')

ark 'test_unzip' do
  url "file://#{fixture_root}/foo.zip"
  checksum 'deea3a324115c9ca0f3078362f807250080bf1b27516f7eca9d34aad863a11e0'
  path '/usr/local/foo_dump'
  creates 'foo1.txt'
  owner 'foobarbaz'
  group 'foobarbaz'
  action :unzip
end
