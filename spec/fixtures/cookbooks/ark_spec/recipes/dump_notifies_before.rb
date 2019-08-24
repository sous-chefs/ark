file '/tmp/ark_notify_before_received' do
  content 'ark_notify_before_received'
  action :nothing
end

ark 'test_dump_notifies_before' do
  url 'https://github.com/burtlo/ark/raw/master/files/default/foo.zip'
  checksum 'deea3a324115c9ca0f3078362f807250080bf1b27516f7eca9d34aad863a11e0'
  path '/usr/local/foo_dump'
  creates 'foo1.txt'
  owner 'foobarbaz'
  group 'foobarbaz'
  action :dump
  notifies :create, 'file[/tmp/ark_notify_before_received]', :before
end
