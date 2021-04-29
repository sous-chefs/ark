module Ark
  module Cookbook
    module Helpers
      def ark_dependencies
        pkgs = %w(libtool autoconf) unless platform_family?('mac_os_x')
        pkgs += %w(make) unless platform_family?('mac_os_x', 'freebsd')
        pkgs += %w(unzip rsync gcc) unless platform_family?('mac_os_x')
        pkgs += %w(autogen) unless platform_family?('rhel', 'fedora', 'mac_os_x', 'suse', 'amazon')
        pkgs += %w(gtar) if platform?('freebsd', 'smartos')
        pkgs += %w(gmake) if platform?('freebsd')
        if platform_family?('rhel', 'suse', 'amazon')
          if node['platform_version'].to_i >= 7
            pkgs += %w(xz bzip2 tar)
          elsif node['platform_version'].to_i < 7
            pkgs += %w(xz-lzma-compat bzip2 tar)
          end
        elsif platform_family?('fedora')
          pkgs += %w(xz-lzma-compat bzip2 tar)
        end
        pkgs += %w(shtool pkg-config) if platform_family?('debian')

        pkgs
      end
    end
  end
end
