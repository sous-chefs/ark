#
# Cookbook Name:: ark
# Resource:: ArkDump
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
    class ArkDump < Chef::Resource::ArkBase

      def initialize(name, run_context=nil)
        super
        dont_change_env_path
        @resource_name = :ark_dump
        @provider = Chef::Provider::ArkDump
      
      end

      def dont_change_env_path
        undef append_env_path
        undef has_binaries
      end

      def set_paths
        parse_file_name
        @release_file     = ::File.join(Chef::Config[:file_cache_path],  "#{@name}.#{@release_ext}")
      end

      def unzip_cmd
        ::Proc.new {|r|
          require 'mixlib/shellout'
          FileUtils.mkdir_p r.path
          Chef::Log.debug("PATH is #{ENV['PATH']}")
          cmd = Mixlib::ShellOut.new(%Q{unzip  -j -q -u -o '#{r.release_file}' -d '#{r.path}';})
          cmd.run_command
          puts "error messages" + cmd.stderr
          # Raise an exception if it didn't exit with 0
          cmd.error!
#          cmd = Chef::ShellOut.new("unzip", "-q", "-u", "-o", "-j", r.release_file,
 #                                  "-d", r.path, :user => 'root')
#          cmd = Chef::ShellOut.new("unzip -q -u -o -j
          #          #{r.release_file} -d #{r.path}")
#          cmd = Chef::ShellOut.new('unzip')
#          run_context = Chef::RunContext.new(node, {})
#          b = Chef::Resource::Script::Bash.new(r.name, run_context)
#          b.code <<-EOB
#unzip
#EOB
#          b.run_action(:run)
#          b = bash "foo" do
 #           code "unzip"
#            action :nothing
#          end
#          b.run_action(:run)
          # cmd.run_command
#          system("bash -x unzip -j -q -u -o #{r.release_file} -d #{r.path}")
        }
        
      end

      def untar_cmd(sub_cmd)
        ::Proc.new {|r|
          Chef::Application.fatal!("Cannot yet dump paths for tar archives")
        }
      end

      
    end
  end
end

