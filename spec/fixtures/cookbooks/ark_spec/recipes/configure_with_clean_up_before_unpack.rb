
ark 'test_configure' do
  url 'https://github.com/zeromq/libzmq/tarball/master'
  extension 'tar.gz'
  action :configure
  clean_up_before_unpack true
end
