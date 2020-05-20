ark 'test_setup_py_build' do
  url 'https://codeload.github.com/s3tools/s3cmd/tar.gz/master'
  extension 'tar.gz'
  action :setup_py_build
  clean_up_before_unpack true
end
