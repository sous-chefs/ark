# libs

module Opscode
  module Ark
    module ProviderHelpers
      private

      def unpack_type
        case parse_file_extension
        when /tar.gz|tgz/  then "tar_xzf"
        when /tar.bz2|tbz/ then "tar_xjf"
        when /tar.xz|txz/  then "tar_xJf"
        when /zip|war|jar/ then "unzip"
        else fail "Don't know how to expand #{new_resource.url}"
        end
      end

      def parse_file_extension
        if new_resource.extension.nil?
          # purge any trailing redirect
          url = new_resource.url.clone
          url =~ %r{^https?:\/\/.*(.bin|bz2|gz|jar|tbz|tgz|txz|war|xz|zip)(\/.*\/)}
          url.gsub!(Regexp.last_match(2), '') unless Regexp.last_match(2).nil?
          # remove tailing query string
          release_basename = ::File.basename(url.gsub(/\?.*\z/, '')).gsub(/-bin\b/, '')
          # (\?.*)? accounts for a trailing querystring
          Chef::Log.debug("DEBUG: release_basename is #{release_basename}")
          release_basename =~ /^(.+?)\.(jar|tar\.bz2|tar\.gz|tar\.xz|tbz|tgz|txz|war|zip)(\?.*)?/
          Chef::Log.debug("DEBUG: file_extension is #{Regexp.last_match(2)}")
          new_resource.extension = Regexp.last_match(2)
        end
        new_resource.extension
      end

      def unpack_command
        if node['platform_family'] == 'windows'
          cmd = sevenzip_command
        else
          case unpack_type
          when "tar_xzf"
            cmd = tar_command("xzf")
          when "tar_xjf"
            cmd = tar_command("xjf")
          when "tar_xJf"
            cmd = tar_command("xJf")
          when "unzip"
            cmd = unzip_command
          end
        end
        Chef::Log.debug("DEBUG: cmd: #{cmd}")
        cmd
      end

      def tar_command(tar_args)
        cmd = node['ark']['tar']
        cmd += " #{tar_args} "
        cmd += new_resource.release_file
        cmd += tar_strip_args
        cmd
      end

      def unzip_command
        if new_resource.strip_components > 0
          require 'tmpdir'
          tmpdir = Dir.mktmpdir
          strip_dir = '*/' * new_resource.strip_components
          cmd = "unzip -q -u -o #{new_resource.release_file} -d #{tmpdir}"
          cmd += " && rsync -a #{tmpdir}/#{strip_dir} #{new_resource.path}"
          cmd += " && rm -rf #{tmpdir}"
          cmd
        else
          "unzip -q -u -o #{new_resource.release_file} -d #{new_resource.path}"
        end
      end

      def sevenzip_command
        if new_resource.strip_components > 0
          require 'tmpdir'
          tmpdir = Dir.mktmpdir
          cmd = sevenzip_command_builder(tmpdir, 'e')
          cmd += " && "
          currdir = tmpdir
          var = 0
          while var < new_resource.strip_components
            var += 1
            cmd += "for /f %#{var} in ('dir /ad /b \"#{currdir.gsub! '/', '\\'}\"') do "
            currdir += "\\%#{var}"
          end
          cmd += "xcopy \"#{currdir}\" \"#{new_resource.home_dir}\" /s /e"
        else
          cmd = sevenzip_command_builder(new_resource.path, 'x')
        end
        cmd
      end

      def sevenzip_command_builder(dir, command)
        cmd = "#{node['ark']['tar']} #{command} \""
        cmd += new_resource.release_file
        cmd += "\" "
        case parse_file_extension
        when /tar.gz|tgz|tar.bz2|tbz|tar.xz|txz/
          cmd += " -so | #{node['ark']['tar']} x -aoa -si -ttar"
        end
        cmd += " -o\"#{dir}\" -uy"
        cmd
      end

      def dump_command
        if node['platform_family'] == 'windows'
          cmd = sevenzip_command_builder(new_resource.path, 'e')
        else
          case unpack_type
          when "tar_xzf", "tar_xjf", "tar_xJf"
            cmd = "tar -mxf \"#{new_resource.release_file}\" -C \"#{new_resource.path}\""
          when "unzip"
            cmd = "unzip  -j -q -u -o \"#{new_resource.release_file}\" -d \"#{new_resource.path}\""
          end
        end
        Chef::Log.debug("DEBUG: cmd: #{cmd}")
        cmd
      end

      def cherry_pick_command
        if node['platform_family'] == 'windows'
          cmd = sevenzip_command_builder(new_resource.path, 'e')
          cmd += " -r #{new_resource.creates}"
        else
          case unpack_type
          when "tar_xzf"
            cmd = cherry_pick_tar_command("xzf")
          when "tar_xjf"
            cmd = cherry_pick_tar_command("xjf")
          when "tar_xJf"
            cmd = cherry_pick_tar_command("xJf")
          when "unzip"
            cmd = cherry_pick_unzip_command
          end
        end
        Chef::Log.debug("DEBUG: cmd: #{cmd}")
        cmd
      end

      def cherry_pick_unzip_command
        cmd = "unzip -t #{new_resource.release_file} \"*/#{new_resource.creates}\" ; stat=$? ;"
        cmd += "if [ $stat -eq 11 ] ; then "
        cmd += "unzip  -j -o #{new_resource.release_file} \"#{new_resource.creates}\" -d #{new_resource.path} ;"
        cmd += "elif [ $stat -ne 0 ] ; then false ;"
        cmd += "else "
        cmd += "unzip  -j -o #{new_resource.release_file} \"*/#{new_resource.creates}\" -d #{new_resource.path} ;"
        cmd += "fi"
        cmd
      end

      def cherry_pick_tar_command(tar_args)
        cmd = node['ark']['tar']
        cmd += " #{tar_args}"
        cmd += " #{new_resource.release_file}"
        cmd += " -C"
        cmd += " #{new_resource.path}"
        cmd += " #{new_resource.creates}"
        cmd += tar_strip_args
        cmd
      end

      def default_prefix_bin
        new_resource.prefix_bin || prefix_bin_from_node_in_run_context
      end

      def default_prefix_root
        new_resource.prefix_root || prefix_root_from_node_in_run_context
      end

      def default_home_dir
        prefix_home = new_resource.prefix_home || prefix_home_from_node_in_run_context
        ::File.join(prefix_home, new_resource.name)
      end

      def default_version
        new_resource.version || "1"
      end

      def default_path
        if node['platform_family'] == 'windows'
          new_resource.win_install_dir
        else
          ::File.join(new_resource.prefix_root, "#{new_resource.name}-#{new_resource.version}")
        end
      end

      def set_paths
        release_ext = parse_file_extension
        new_resource.prefix_bin = default_prefix_bin
        new_resource.prefix_root = default_prefix_root
        new_resource.home_dir = default_home_dir
        new_resource.version = default_version
        new_resource.path = default_path

        Chef::Log.debug("path is #{new_resource.path}")
        new_resource.release_file = ::File.join(Chef::Config[:file_cache_path],  "#{new_resource.name}-#{new_resource.version}.#{release_ext}")
      end

      def node_in_run_context
        new_resource.run_context.node
      end

      def prefix_home_from_node_in_run_context
        node_in_run_context['ark']['prefix_home']
      end

      def prefix_bin_from_node_in_run_context
        node_in_run_context['ark']['prefix_bin']
      end

      def prefix_root_from_node_in_run_context
        node_in_run_context['ark']['prefix_root']
      end

      def set_put_paths
        release_ext = parse_file_extension
        path = new_resource.path.nil? ? prefix_root_from_node_in_run_context : new_resource.path
        new_resource.path      = ::File.join(path, new_resource.name)
        Chef::Log.debug("DEBUG: path is #{new_resource.path}")
        new_resource.release_file     = ::File.join(Chef::Config[:file_cache_path],  "#{new_resource.name}.#{release_ext}")
      end

      def set_dump_paths
        release_ext = parse_file_extension
        new_resource.release_file  = ::File.join(Chef::Config[:file_cache_path],  "#{new_resource.name}.#{release_ext}")
      end

      def tar_strip_args
        new_resource.strip_components > 0 ? " --strip-components=#{new_resource.strip_components}" : ""
      end

      def show_deprecations
        return unless [true, false].include?(new_resource.strip_leading_dir)
        Chef::Log.warn("DEPRECATED: strip_leading_dir attribute was deprecated. Use strip_components instead.")
      end

      def owner_command
        if node['platform_family'] == 'windows'
          "icacls #{new_resource.path}\\* /setowner #{new_resource.owner}"
        else
          "chown -R #{new_resource.owner}:#{new_resource.group} #{new_resource.path}"
        end
      end
    end
  end
end
