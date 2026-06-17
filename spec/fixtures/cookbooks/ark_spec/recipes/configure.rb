fixture_root = ::File.join(run_context.cookbook_collection['ark'].root_dir, 'files', 'default')

ark 'test_configure' do
  url "file://#{fixture_root}/configure_fixture.tar.gz"
  extension 'tar.gz'
  action :configure
end
