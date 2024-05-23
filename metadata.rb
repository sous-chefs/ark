name              'ark'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Provides a custom resource for installing runtime artifacts in a predictable fashion'
version           '6.0.29'
source_url        'https://github.com/sous-chefs/ark'
issues_url        'https://github.com/sous-chefs/ark/issues'
chef_version      '>= 15.3'

supports 'amazon'
supports 'centos'
supports 'debian'
supports 'freebsd'
supports 'mac_os_x'
supports 'opensuse'
supports 'opensuseleap'
supports 'oracle'
supports 'redhat'
supports 'scientific'
supports 'smartos'
supports 'suse'
supports 'ubuntu'
supports 'windows'

depends 'seven_zip', '>= 3.1' # for windows os
