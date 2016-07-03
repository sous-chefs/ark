name             'ark'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Provides a custom resource for installing runtime artifacts in a predictable fashion'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.2.0'

recipe 'ark::default', 'Installs packages needed by the custom resource'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon windows mac_os_x smartos freebsd).each do |os|
  supports os
end

depends 'build-essential'
depends 'windows' # for windows os
depends 'seven_zip' # for windows os

source_url 'https://github.com/chef-cookbooks/ark' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/ark/issues' if respond_to?(:issues_url)

chef_version '>= 11.0' if respond_to?(:chef_version)
