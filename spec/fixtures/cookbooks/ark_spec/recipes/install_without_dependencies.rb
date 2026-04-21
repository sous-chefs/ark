ark 'test_install_without_dependencies' do
  url 'https://raw.githubusercontent.com/sous-chefs/ark/main/files/default/foo.tar.gz'
  checksum '5996e676f17457c823d86f1605eaa44ca8a81e70d6a0e5f8e45b51e62e0c52e8'
  version '2'
  prefix_root '/usr/local'
  owner 'foobarbaz'
  group 'foobarbaz_group'
  install_dependencies false
  action :install
end
