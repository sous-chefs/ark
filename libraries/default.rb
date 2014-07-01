# libs
require_relative 'resource_deprecations'
require_relative 'resource_defaults'
require_relative 'commands'


module Opscode
  module Ark
    module ProviderHelpers

      def deprecations
        ::Ark::ResourceDeprecations.on(new_resource)
      end

      def show_deprecations
        deprecations.each { |message| Chef::Log.warn("DEPRECATED: #{message}") }
      end

      def defaults
        @resource_defaults ||= ::Ark::ResourceDefaults.new(new_resource)
      end

      def set_paths
        new_resource.extension = defaults.extension
        new_resource.prefix_bin = defaults.prefix_bin
        new_resource.prefix_root = defaults.prefix_root
        new_resource.home_dir = defaults.home_dir
        new_resource.version = defaults.version

        # TODO: what happens when the path is already set -- with the current logic we overwrite it\
        # if you are in windows we overwrite it
        # otherwise we overwrite it with the root/name-version
        new_resource.path = defaults.path
        new_resource.release_file = defaults.release_file
      end

      def set_put_paths
        new_resource.extension = defaults.extension

        # TODO: Should this be added - as the prefix_root could be used in the path_with_version
        # new_resource.prefix_root = default.prefix_root
        new_resource.path = defaults.path_without_version
        new_resource.release_file = defaults.release_file_without_version
      end

      def set_dump_paths
        new_resource.extension = defaults.extension
        new_resource.release_file = defaults.release_file_without_version
      end

      def unpack_command
        if node['platform_family'] == 'windows'
          WindowsUnpacker.new(new_resource).command
        else
          case unpack_type
          when "tar_xzf"
            TarUnpacker.new(new_resource,flags: "xzf").command
          when "tar_xjf"
            TarUnpacker.new(new_resource,flags: "xjf").command
          when "tar_xJf"
            TarUnpacker.new(new_resource,flags: "xJf").command
          when "unzip"
            UnzipUnpacker.new(new_resource).command
          end
        end
      end

      def dump_command
        if node['platform_family'] == 'windows'
          WindowsDumper.new(new_resource).command
        else
          case unpack_type
          when "tar_xzf", "tar_xjf", "tar_xJf"
            TarDumper.new(new_resource).command
          when "unzip"
            UnzipDumper.new(new_resource).command
          end
        end
      end

      def cherry_pick_command
        if node['platform_family'] == 'windows'
          WindowsCherryPicker.new(new_resource).command
        else
          case unpack_type
          when "tar_xzf"
            TarCherryPicker.new(new_resource, flags: "xzf").command
          when "tar_xjf"
            TarCherryPicker.new(new_resource, flags: "xjf").command
          when "tar_xJf"
            TarCherryPicker.new(new_resource, flags: "xJf").command
          when "unzip"
            UnzipCherryPicker.new(new_resource).command
          end
        end
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

      def owner_command
        if node['platform_family'] == 'windows'
          WindowsOwner.new(new_resource).command
        else
          GeneralOwner.new(new_resource).command
        end
      end


      # private
      def unpack_type
        case new_resource.extension
        when /tar.gz|tgz/  then "tar_xzf"
        when /tar.bz2|tbz/ then "tar_xjf"
        when /tar.xz|txz/  then "tar_xJf"
        when /zip|war|jar/ then "unzip"
        else fail "Don't know how to expand #{new_resource.url}"
        end
      end

    end
  end
end
