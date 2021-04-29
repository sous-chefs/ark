unified_mode true
include Ark::Cookbook::Helpers

property :package_dependencies,
      Array,
      default: lazy { ark_dependencies },
      description: 'An array of packages to install'

action :install do
  package new_resource.package_dependencies unless platform_family?('windows', 'mac_os_x')

  seven_zip_tool if platform_family?('windows')
end

action :remove do
  package 'Remove packages' do
    package_name new_resource.package_dependencies unless platform_family?('windows', 'mac_os_x')
    action :remove
  end

  # Not yet implemented
  # if platform_family?('windows') do
  #   seven_zip_tool 'uninstall' do
  #     action :uninstall
  #   end
  # end
end
