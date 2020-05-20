name             'ark_spec'
maintainer       'Bryan W. Berry'
maintainer_email 'bryan.berry@gmail.com'
license          'Apache-2.0'
description      'Installs/Configures ark'
version          '0.9.1'

%w( debian ubuntu centos redhat fedora windows ).each do |os|
  supports os
end

depends 'ark'
