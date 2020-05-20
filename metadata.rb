name             'ark'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache-2.0'
description      'Provides a custom resource for installing runtime artifacts in a predictable fashion'
version          '5.0.0'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon windows mac_os_x smartos freebsd).each do |os|
  supports os
end

depends 'seven_zip' # for windows os

source_url 'https://github.com/chef-cookbooks/ark'
issues_url 'https://github.com/chef-cookbooks/ark/issues'
chef_version '>= 14.0'
