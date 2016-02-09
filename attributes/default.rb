#
# Cookbook Name:: ark
# Attributes:: default
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['ark']['apache_mirror'] = 'http://apache.mirrors.tds.net'
default['ark']['prefix_root'] = '/usr/local'
default['ark']['prefix_bin'] = '/usr/local/bin'
default['ark']['prefix_home'] = '/usr/local'
default['ark']['tar'] = if node['platform_family'] == 'windows'
                          "\"#{node['7-zip']['home']}\\7z.exe\""
                        else
                          '/bin/tar'
                        end

pkgs = %w(libtool autoconf) unless platform_family?('mac_os_x', 'windows')
pkgs += %w(unzip rsync make gcc) unless platform_family?('mac_os_x', 'windows')
pkgs += %w(autogen) unless platform_family?('rhel', 'fedora', 'mac_os_x', 'suse', 'windows')
pkgs += %w(gtar) if platform?('freebsd')
pkgs += %w(xz-lzma-compat bzip2) if platform?('centos')
pkgs += %w(tar) if platform_family?('rhel', 'fedora')
pkgs += %w(shtool pkg-config) if platform_family?('debian')

default['ark']['package_dependencies'] = pkgs
