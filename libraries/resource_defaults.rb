module Ark
  class ResourceDefaults
    # def windows?
    #   node_in_run_context['platform_family'] == 'windows'
    # end

    def path_without_version
      partial_path = resource.path || prefix_root_from_node_in_run_context
      ::File.join(partial_path, resource.name)
    end

    def release_file
      release_filename = "#{resource.name}-#{resource.version}.#{resource.extension}"
      ::File.join(file_cache_path, release_filename)
    end

    def release_file_without_version
      release_filename = "#{resource.name}.#{resource.extension}"
      ::File.join(file_cache_path, release_filename)
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

    def wmi_property_from_query(wmi_property, wmi_query)
      @wmi = ::WIN32OLE.connect('winmgmts://')
      result = @wmi.ExecQuery(wmi_query)
      return unless result.each.count > 0
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
