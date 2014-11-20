default['ark']['apache_mirror'] = 'http://apache.mirrors.tds.net'
default['ark']['prefix_root'] = '/usr/local'
default['ark']['prefix_bin'] = '/usr/local/bin'
default['ark']['prefix_home'] = '/usr/local'
case node['platform_family']
  when 'windows'
    default['ark']['tar'] = "\"#{default['7-zip']['home']}\\7z.exe\""
  when 'mac_os_x'
    default['ark']['tar'] = '/usr/bin/tar'
  else
    default['ark']['tar'] = '/bin/tar'
end

pkgs = %w(libtool autoconf) unless platform_family?('mac_os_x', 'windows')
pkgs += %w(unzip rsync make gcc) unless platform_family?('mac_os_x', 'windows')
pkgs += %w(autogen) unless platform_family?('rhel', 'fedora', 'mac_os_x', 'suse', 'windows')
pkgs += %w(gtar) if platform?('freebsd')
pkgs += %w(xz-lzma-compat) if platform?('centos')

default['ark']['package_dependencies'] = pkgs
