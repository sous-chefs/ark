provides :ark_prereq
unified_mode true

property :package_dependencies, Array, default: lazy { ::Ark::PlatformDefaults.package_dependencies(run_context.node) }

action :install do
  if platform_family?('windows')
    seven_zip_tool new_resource.name
  elsif new_resource.package_dependencies.any?
    package "#{new_resource.name} package dependencies" do
      package_name new_resource.package_dependencies
      action :install
    end
  end
end
