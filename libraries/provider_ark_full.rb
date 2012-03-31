#
# Cookbook Name:: ark
# Provider:: Ark
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
    class Ark < Chef::Provider::ArkBase
      
      def action_install
        super
        action_link
      end

      def action_link
        unless new_resource.home_dir == new_resource.path
          l = Chef::Resource::Link.new(new_resource.home_dir, run_context)
          l.to new_resource.path
          l.run_action(:create)
        end
      end

      private

      def set_paths
        release_ext = parse_file_extension
        starting_path = new_resource.path.clone
        new_resource.path      = ::File.join(new_resource.path, "#{new_resource.name}-#{new_resource.version}")
        new_resource.home_dir  ||= ::File.join(starting_path, "#{new_resource.name}")
        Chef::Log.debug("path is #{new_resource.path}")
        new_resource.release_file  = ::File.join(Chef::Config[:file_cache_path],
                                                 "#{new_resource.name}-#{new_resource.version}.#{release_ext}")
      end

    end
  end
end

