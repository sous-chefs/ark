name             'ark'
maintainer       'Franklin Webber'
maintainer_email 'frank@chef.io'
license          'Apache 2.0'
description      'Provides a custom resource for installing runtime artifacts in a predictable fashion'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.1'

recipe 'ark::default', 'Installs packages needed by the custom resource'

%w(ubuntu debian redhat centos suse scientific oracle amazon windows mac_os_x smartos freebsd).each do |os|
  supports os
end

depends 'build-essential'
depends 'windows' # for windows os
depends 'seven_zip' # for windows os

source_url 'https://github.com/burtlo/ark' if respond_to?(:source_url)
issues_url 'https://github.com/burtlo/ark/issues' if respond_to?(:issues_url)
