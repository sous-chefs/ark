file '/tmp/ark_notify_before_received' do
  content 'ark_notify_before_received'
  action :nothing
end

ark 'test_install_notifies_before' do
  url 'https://github.com/burtlo/ark/raw/master/files/default/foo.tar.gz'
  checksum '5996e676f17457c823d86f1605eaa44ca8a81e70d6a0e5f8e45b51e62e0c52e8'
  version '2'
  prefix_root '/usr/local'
  owner 'foobarbaz'
  group 'foobarbaz_group'
  action :install
  notifies :create, 'file[/tmp/ark_notify_before_received]', :before
end
