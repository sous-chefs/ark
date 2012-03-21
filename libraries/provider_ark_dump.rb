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

class Chef
  class Provider
    class ArkDump < Chef::Provider::ArkBase

      def action_install
        new_resource.set_paths
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
        stop_file_path = ::File.join(new_resource.path,
                    new_resource.stop_file)
        if new_resource.stop_file and ::File.exist?(stop_file_path)
            true
        else
          false
        end
      end

    end
  end
end

