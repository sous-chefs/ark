#
# Cookbook Name:: ark
# Provider:: ArkBase
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

class Chef
  class Provider
    class ArkBase < Chef::Provider
      
      def load_current_resource
        @current_resource = Chef::Resource::ArkBase.new(@new_resource.name)
      end
      
      def action_download
        run_context = Chef::RunContext.new(node, {})
        f = Chef::Resource::RemoteFile.new(new_resource.release_file, run_context)
        f.source new_resource.url
        if new_resource.checksum
          f.checksum new_resource.checksum
        end
        f.run_action(:create)
      end
      
      def action_install
        new_resource.set_paths
        unless exists?
          action_download
          action_unpack
        else
          Chef::Log.debug("Ark already exists")
        end
        action_set_owner
        action_install_binaries
      end

      def action_unpack
        run_context = Chef::RunContext.new(node, {})
        d = Chef::Resource::Directory.new(new_resource.path, run_context)
        d.mode '0755'
        d.recursive true
        d.run_action(:create)
        new_resource.expand_cmd.call(new_resource)
      end

      def action_set_owner
        require 'fileutils'
        FileUtils.chown_R new_resource.owner, new_resource.owner, new_resource.path
      end

      def action_install_binaries
        if not new_resource.has_binaries.empty?
          new_resource.has_binaries.each do |bin|
            file_name = ::File.join('/usr/local/bin', ::File.basename(bin))
            run_context = Chef::RunContext.new(node, {})
            l = Chef::Resource::Link.new(file_name, run_context)
            
            l.to ::File.join(new_resource.path, bin)
            l.run_action(:create)
          end
        elsif new_resource.append_env_path
          new_path = "$PATH:#{::File.join(new_resource.path, 'bin').to_s}"
          Chef::Log.debug("new_path is #{new_path}")
          run_context = Chef::RunContext.new(node, {})
          path = "/etc/profile.d/#{new_resource.name}.sh"
          f = Chef::Resource::File.new(path, run_context)
          f.content <<-EOF
          export PATH=#{new_path}
          EOF
          f.mode 0755
          f.owner 'root'
          f.group 'root'
          f.run_action(:create)
          ENV['PATH'] = new_path
        end
      end
      
      private

      def exists?
        if new_resource.stop_file and !(new_resource.stop_file.empty?)
          if  ::File.exist?(::File.join(new_resource.path,
                                        new_resource.stop_file))
            true
          else
            false
          end
        elsif !::File.exists?(new_resource.path) or
            ::File.stat("#{new_resource.path}/").nlink == 2
          false
        else
          true
        end
      end

  
    end
  end
end

