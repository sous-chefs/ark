#
# Cookbook Name:: ark
# Resource:: ArkBase
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

require 'chef/resource'

class Chef
  class Resource
    class ArkBase < Chef::Resource

      def initialize(name, run_context=nil)
        super
        @resource_name = :ark_base
        @owner = 'root'
        @url = nil
        @append_env_path = false
        @strip_leading_dir = true
        @checksum = nil
        @path = '/usr/local'
        @has_binaries = []
        @release_file = ''
        @creates = nil
        @allowed_actions.push(:install)
        @action = :install
        @provider = Chef::Provider::ArkBase
      end

      attr_accessor :path, :release_file
      
      def owner(arg=nil)
        set_or_return(
                      :owner,
                      arg,
                      :kind_of => String)
      end

      def url(arg=nil)
        set_or_return(
                      :url,
                      arg,
                      :kind_of => String,
                      :required => true)
      end

      def path(arg=nil)
        set_or_return(
                      :path,
                      arg,
                      :kind_of => String)
      end

      
      def append_env_path(arg=nil)
        set_or_return(
                      :append_env_path,
                      arg,
                      :kind_of => [TrueClass, FalseClass]
                      )
      end

      
      def checksum(arg=nil)
        set_or_return(
                      :checksum,
                      arg,
                      :regex => /^[a-zA-Z0-9]{64}$/)
      end

      def has_binaries(arg=nil)
        set_or_return(
                      :has_binaries,
                      arg,
                      :kind_of => Array
                      )
      end

      def creates(arg=nil)
        set_or_return(
                      :creates,
                      arg,
                      :kind_of => String
                      )
      end

      def release_file(arg=nil)
        set_or_return(
                      :release_file,
                      arg,
                      :kind_of => String
                      )
      end

      def strip_leading_dir(arg=nil)
        set_or_return(
                      :strip_leading_dir,
                      arg,
                      :kind_of => String
                      )
      end


    end
  end
end

