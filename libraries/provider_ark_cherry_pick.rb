#
# Cookbook Name:: ark
# Provider:: ArkCherryPick
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
      class ArkCherryPick < Chef::Provider::ArkBase
      
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

      def set_paths
        release_ext = parse_file_extension
        new_resource.release_file = ::File.join(Chef::Config[:file_cache_path],
                                                "#{new_resource.name}.#{release_ext}")
      end

      def unzip_cmd
          FileUtils.mkdir_p new_resource.path
          b = Chef::Resource::Script::Bash.new(new_resource.name, run_context)
          b.code <<-EOS
          unzip  -j -o #{new_resource.release_file} "*/#{new_resource.pick}" -d #{new_resource.path}
          EOS
          b.run_action(:run)
      end


      def untar_cmd(sub_cmd)
        FileUtils.mkdir_p new_resource.path
        dest = ::File.join(new_resource.path, new_resource.pick)
        cmd = Chef::ShellOut.new(%Q{tar --no-anchored -O -#{sub_cmd} '#{new_resource.release_file}' #{new_resource.pick} > '#{dest}';})
        cmd.run_command
        cmd.error!
      end
     
      def exists?
        creates_path = ::File.join(new_resource.path,
                    new_resource.pick)
        if new_resource.pick and ::File.exist?(creates_path)
            true
        else
          false
        end
      end

    end
  end
end

