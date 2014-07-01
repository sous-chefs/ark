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
            TarCommandBuilder.new(new_resource,flags: "xzf").unpack
          when "tar_xjf"
            TarCommandBuilder.new(new_resource,flags: "xjf").unpack
          when "tar_xJf"
            TarCommandBuilder.new(new_resource,flags: "xJf").unpack
          when "unzip"
            UnzipCommandBuilder.new(new_resource).unpack
          end
        end
      end

      def dump_command
        if node['platform_family'] == 'windows'
          WindowsDumper.new(new_resource).command
        else
          case unpack_type
          when "tar_xzf", "tar_xjf", "tar_xJf"
            TarCommandBuilder.new(new_resource).dump
          when "unzip"
            UnzipCommandBuilder.new(new_resource).dump
          end
        end
      end

      def cherry_pick_command
        if node['platform_family'] == 'windows'
          WindowsCherryPicker.new(new_resource).command
        else
          case unpack_type
          when "tar_xzf"
            TarCommandBuilder.new(new_resource, flags: "xzf").cherry_pick
          when "tar_xjf"
            TarCommandBuilder.new(new_resource, flags: "xjf").cherry_pick
          when "tar_xJf"
            TarCommandBuilder.new(new_resource, flags: "xJf").cherry_pick
          when "unzip"
            UnzipCommandBuilder.new(new_resource).cherry_pick
          end
        end
      end

      def unzip_command
        UnzipCommandBuilder.new(new_resource).unpack
      end

      def owner_command
        if node['platform_family'] == 'windows'
          WindowsOwner.new(new_resource).command
        else
          GeneralOwner.new(new_resource).command
        end
      end

      def unpack_type
        new_resource.unpack_type ||= defaults.unpack_type
      end

    end
  end
end
