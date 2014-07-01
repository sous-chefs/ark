# libs
require_relative 'resource_deprecations'
require_relative 'resource_defaults'
require_relative 'commands'

module PlatformSpecificBuilders

  def generates_archive_commands_for(application,options)
    condition = options[:when_the]
    builder = options[:with_builder_klass]
    archive_command_generators.push [ condition, builder ]
  end

  def archive_command_generators
    @archive_command_generators ||= []
  end

end

module Opscode
  module Ark
    module ProviderHelpers
      extend PlatformSpecificBuilders

      generates_archive_commands_for :seven_zip,
        when_the: -> { node['platform_family'] == 'windows' },
        with_builder_klass: SevenZipCommandBuilder

      generates_archive_commands_for :unzip,
        when_the: -> { new_resource.extension =~ /zip|war|jar/ },
        with_builder_klass: UnzipCommandBuilder

      generates_archive_commands_for :tar,
        when_the: -> { true },
        with_builder_klass: TarCommandBuilder

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
        archive_application.unpack
      end

      def dump_command
        archive_application.dump
      end

      def cherry_pick_command
        archive_application.cherry_pick
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

      private

      def archive_application
        @archive_application ||= builder_klass.new(new_resource)
      end

      def builder_klass
        new_resource.extension ||= defaults.extension
        Opscode::Ark::ProviderHelpers.archive_command_generators.find { |condition, klass| instance_exec(&condition) }.last
      end

    end
  end
end
