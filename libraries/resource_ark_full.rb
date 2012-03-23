#
# Cookbook Name:: ark
# Resource:: Ark
#
# Author:: Bryan W. Berry <bryan.berry@gmail.com>
# Copyright 2012, Bryan W. Berry
# Copyright 2011, Infochimps
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

require 'chef/resource'

class Chef
  class Resource
    class Ark < Chef::Resource::ArkBase

      include Chef::Mixin::ShellOut

      def initialize(name, run_context=nil)
        super
        @resource_name = :ark
        @prefix_root = "/usr/local"
        @action = :install
        @provider = Chef::Provider::Ark
      end

      def version(arg=nil)
        set_or_return(
                      :version,
                      arg,
                      :kind_of => String,
                      :required => true
                      )
      end
      
      def home_dir(arg=nil)
        set_or_return(
                      :home_dir,
                      arg,
                      :kind_of => String
                      )
      end

      def set_paths
        parse_file_name
        @path      = ::File.join(@path, "#{@name}-#{@version}")
        @home_dir  ||= ::File.join(@path, "#{@name}")
        Chef::Log.debug("path is #{@path}")
        @release_file     = ::File.join(Chef::Config[:file_cache_path],  "#{@name}-#{@version}.#{@release_ext}")
      end
      
      private

      def parse_file_name
        release_basename = ::File.basename(@url.gsub(/\?.*\z/, '')).gsub(/-bin\b/, '')
        # (\?.*)? accounts for a trailing querystring
        release_basename =~ %r{^(.+?)\.(tar\.gz|tar\.bz2|zip|war|jar)(\?.*)?}
        @release_ext      = $2
      end
      
    end
  end
end

