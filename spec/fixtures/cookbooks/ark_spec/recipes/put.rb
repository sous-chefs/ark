fixture_root = ::File.join(run_context.cookbook_collection['ark'].root_dir, 'files', 'default')

ark 'test_put' do
  url "file://#{fixture_root}/foo.tar.gz"
  checksum '5996e676f17457c823d86f1605eaa44ca8a81e70d6a0e5f8e45b51e62e0c52e8'
  owner 'foobarbaz'
  group 'foobarbaz'
  action :put
end
