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
require File.expand_path('resource_ark.rb',      File.dirname(__FILE__))


class Chef
  class Resource
    class Ark < Chef::Resource::ArkBase

      def initialize(name, run_context=nil)
        super
        @resource_name = :ark
        @action = :install
        @home_dir = nil
        @provider = Chef::Provider::Ark
        @environment = {}
        @allowed_actions.push(:install_with_make)
        @autoconf_opts = []
        @make_opts = []
      end

      attr_accessor :prefix_root, :home_dir
      
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

      def environment(arg=nil)
        set_or_return(
                      :environment,
                      arg,
                      :kind_of => Hash
                      )
      end

      def autoconf_opts(arg=nil)
        set_or_return(
                      :autoconf_opts,
                      arg,
                      :kind_of => Array
                      )
      end

      def make_opts(arg=nil)
        set_or_return(
                      :make_opts,
                      arg,
                      :kind_of => Array
                      )
      end

      
    end
  end
end

