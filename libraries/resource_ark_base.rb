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

      include Chef::Mixin::ShellOut

      def initialize(name, run_context=nil)
        super
        @resource_name = :ark_base
        @owner = 'root'
        @url = nil
        @append_env_path = false
        @strip_leading_dir = true
        @checksum = nil
        @release_ext = ''
        @path = '/usr/local'
        @expand_cmd = nil
        @has_binaries = []
        @stop_file = nil
        @allowed_actions.push(:install)
        @action = :install
        @provider = Chef::Provider::ArkBase
      end

      def owner(arg=nil)
        set_or_return(
                      :owner,
                      arg,
                      :kind_of => String)
      end

      def url(arg=nil)
        if arg
          unless arg =~ /^(http|ftp).*$/
            arg = set_apache_url(url)
          end
        end
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

      def stop_file(arg=nil)
        set_or_return(
                      :stop_file,
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

      def expand_cmd
        cmd = case @release_ext
              when 'tar.gz'  then untar_cmd('xzf')
              when 'tar.bz2' then untar_cmd('xjf')
              when /zip|war|jar/ then unzip_cmd
              else raise "Don't know how to expand #{url} which has extension '#{release_ext}'"
              end
      end

      def strip_leading_dir(arg=nil)
        set_or_return(
                      :strip_leading_dir,
                      arg,
                      :kind_of => String
                      )
      end

      def set_paths
        parse_file_name
        @path      = ::File.join(@path, "#{@name}")
        Chef::Log.debug("path is #{@path}")
        @release_file     = ::File.join(Chef::Config[:file_cache_path],  "#{@name}.#{@release_ext}")
      end
      
      private

      def parse_file_name
        release_basename = ::File.basename(@url.gsub(/\?.*\z/, '')).gsub(/-bin\b/, '')
        # (\?.*)? accounts for a trailing querystring
        release_basename =~ %r{^(.+?)\.(tar\.gz|tar\.bz2|zip|war|jar)(\?.*)?}
        @release_ext      = $2
      end
      
      def set_apache_url(url_ref)
        raise "Missing required resource attribute url" unless url_ref
        url_ref.gsub!(/:name:/,          name.to_s)
        url_ref.gsub!(/:version:/,       version.to_s)
        url_ref.gsub!(/:apache_mirror:/, node['install_from']['apache_mirror'])
        url_ref
      end

      
      def unzip_cmd
        ::Proc.new {|r|
          FileUtils.mkdir_p r.path
          if r.strip_leading_dir
            require 'tmpdir'
            tmpdir = Dir.mktmpdir
            cmd = Chef::ShellOut.new("unzip  -q -u -o '#{r.release_file}' -d '#{tmpdir}'")
            cmd.run_command
            cmd.error!
            subdirectory_children = Dir.glob("#{tmpdir}/**")
            FileUtils.mv subdirectory_children, r.path
            FileUtils.rm_rf tmpdir
          else
            cmd = Chef::ShellOut.new("unzip  -q -u -o #{r.release_file} -d #{r.path}")
            cmd.run_command
            cmd.error!
          end 
        }
      end

      def untar_cmd(sub_cmd)
        ::Proc.new {|r|
          FileUtils.mkdir_p r.path
          if r.strip_leading_dir
            strip_argument = "--strip-components=1"
          else
            strip_argument = ""
          end
          run_context = Chef::RunContext.new(node, {})
          b = Chef::Resource::Script::Bash.new(r.name, run_context)
          cmd = %Q{tar -#{sub_cmd} #{r.release_file} #{strip_argument} -C #{r.path} }
          b.flags "-x"
          b.code <<-EOH
          tar -#{sub_cmd} #{r.release_file} #{strip_argument} -C #{r.path}
          EOH
          b.run_action(:run)
        }
      end

    end
  end
end

