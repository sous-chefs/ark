#
# Cookbook Name:: ark
# Provider:: ArkDump
#
# Author:: Bryan W. Berry <bryan.berry@gmail.com>
# Copyright 2012, Bryan W. Berry
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

require 'chef/provider'
require File.expand_path('provider_ark.rb',      File.dirname(__FILE__))

class Chef
  class Provider
    class ArkDump < Chef::Provider::ArkBase

      def action_install
        set_paths
        unless exists?
          action_download
          action_unpack
        else
          Chef::Log.debug("Ark already exists")
        end
        action_set_owner
      end

      
      private
      
      def exists?
        creates_path = ::File.join(new_resource.path,
                    new_resource.creates)
        new_resource.creates and ::File.exist?(creates_path)
      end

      def set_paths
        release_ext = parse_file_extension
        new_resource.release_file = ::File.join(Chef::Config[:file_cache_path],
                                                "#{new_resource.name}.#{release_ext}")
      end

      def unzip_cmd
        FileUtils.mkdir_p new_resource.path
        cmd = Chef::ShellOut.new(%Q{unzip  -j -q -u -o '#{new_resource.release_file}' -d '#{new_resource.path}'})
        cmd.run_command
        cmd.error!
      end

      def untar_cmd(sub_cmd)
        Chef::Application.fatal!("Cannot yet dump paths for tar archives")
      end

      
    end
  end
end

