module Ark
  module PlatformDefaults
    module_function

    def prefix_root
      '/usr/local'
    end

    def prefix_bin
      '/usr/local/bin'
    end

    def prefix_home
      '/usr/local'
    end

    def version
      '1'
    end

    def package_dependencies(node)
      return [] if platform_family?(node, 'windows', 'mac_os_x')

      pkgs = %w(libtool autoconf)
      pkgs += %w(ca-certificates) unless platform_family?(node, 'freebsd') || platform?(node, 'smartos')
      pkgs += %w(make) unless platform_family?(node, 'freebsd')
      pkgs += %w(unzip rsync gcc)
      pkgs += %w(autogen) unless platform_family?(node, 'rhel', 'fedora', 'suse', 'amazon')
      pkgs += %w(gtar) if platform?(node, 'freebsd', 'smartos')
      pkgs += %w(gmake) if platform?(node, 'freebsd')

      if platform_family?(node, 'rhel', 'suse', 'amazon')
        pkgs += if node['platform_version'].to_i >= 7
                  %w(xz bzip2 tar)
                else
                  %w(xz-lzma-compat bzip2 tar)
                end
      elsif platform_family?(node, 'fedora')
        pkgs += %w(xz-lzma-compat bzip2 tar)
      end

      pkgs += %w(bzip2 xz-utils shtool pkg-config) if platform_family?(node, 'debian')
      pkgs
    end

    def tar_binary(node)
      case node['platform_family']
      when 'mac_os_x', 'freebsd'
        '/usr/bin/tar'
      when 'smartos'
        '/bin/gtar'
      else
        platform?(node, 'smartos') ? '/bin/gtar' : '/bin/tar'
      end
    end

    def platform_family?(node, *families)
      families.include?(node['platform_family'])
    end

    def platform?(node, *platforms)
      platforms.include?(node['platform'])
    end
  end
end
