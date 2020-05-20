ark 'test_install_with_make' do
  url 'https://github.com/dosyfier/ark/raw/develop/files/default/haproxy-ss-20120403.tar.gz'
  version '1.5'
  checksum 'ba0424bf7d23b3a607ee24bbb855bb0ea347d7ffde0bec0cb12a89623cbaf911'
  make_opts ['TARGET=linux26']
  action :install_with_make
  clean_up_before_unpack true
end
