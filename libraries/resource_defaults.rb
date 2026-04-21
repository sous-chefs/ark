module Ark
  class ResourceDefaults
    def extension
      resource.extension || generate_extension_from_url(resource.url.clone)
    end

    def prefix_bin
      resource.prefix_bin || ::Ark::PlatformDefaults.prefix_bin
    end

    def prefix_root
      resource.prefix_root || ::Ark::PlatformDefaults.prefix_root
    end

    def home_dir
      if resource.home_dir.nil? || resource.home_dir.empty?
        prefix_home = resource.prefix_home || ::Ark::PlatformDefaults.prefix_home
        ::File.join(prefix_home, resource.name)
      else
        resource.home_dir
      end
    end

    def version
      resource.version || ::Ark::PlatformDefaults.version
    end

    def path
      return resource.path unless resource.path.nil? || resource.path.empty?
      return resource.win_install_dir if windows?

      ::File.join(prefix_root, "#{resource.name}-#{version}")
    end

    def owner
      resource.owner || default_owner
    end

    def windows?
      node_in_run_context['platform_family'] == 'windows'
    end

    def path_without_version
      partial_path = resource.path || prefix_root
      ::File.join(partial_path, resource.name)
    end

    def release_file
      return resource.release_file unless resource.release_file.nil? || resource.release_file.empty?

      release_filename = "#{resource.name}-#{version}.#{resource.extension}"
      ::File.join(file_cache_path, release_filename)
    end

    def release_file_without_version
      return resource.release_file unless resource.release_file.nil? || resource.release_file.empty?

      release_filename = "#{resource.name}.#{resource.extension}"
      ::File.join(file_cache_path, release_filename)
    end

    def initialize(resource)
      @resource = resource
    end

    private

    attr_reader :resource

    def generate_extension_from_url(url)
      # purge any trailing redirect
      url =~ %r{^https?:\/\/.*(.bin|bz2|gz|jar|tbz|tgz|txz|war|xz|zip|7z)(\/.*\/)}
      url.gsub!(Regexp.last_match(2), '') unless Regexp.last_match(2).nil?
      # remove trailing query string
      release_basename = ::File.basename(url.gsub(/\?.*\z/, '')).gsub(/-bin\b/, '')
      # (\?.*)? accounts for a trailing querystring
      Chef::Log.debug("DEBUG: release_basename is #{release_basename}")
      release_basename =~ /^(.+?)\.(jar|tar\.bz2|tar\.gz|tar\.xz|tbz|tgz|txz|war|zip|tar|7z)(\?.*)?/
      Chef::Log.debug("DEBUG: file_extension is #{Regexp.last_match(2)}")
      Regexp.last_match(2)
    end

    def default_owner
      if windows?
        wmi_property_from_query(:name, "select * from Win32_UserAccount where sid like 'S-1-5-21-%-500' and LocalAccount=True")
      else
        'root'
      end
    end

    def wmi_property_from_query(wmi_property, wmi_query)
      @wmi = ::WIN32OLE.connect('winmgmts://')
      result = @wmi.ExecQuery(wmi_query)
      return unless result.each.any?
      result.each.next.send(wmi_property)
    end

    def file_cache_path
      Chef::Config[:file_cache_path]
    end

    def node_in_run_context
      resource.run_context.node
    end
  end
end
