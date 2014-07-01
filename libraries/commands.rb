
require_relative 'windows_commands'
require_relative 'unzip_commands'
require_relative 'tar_commands'

class UnpackCommander
  def self.choose(resource)
    if resource.run_context.node['platform_family'] == 'windows'
      WindowsUnpacker.new(resource)
    elsif true
      TarUnpacker.new(resource)
    else
      UnzipUnpacker.new(resource)
    end
  end
end

class GeneralOwner
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    "chown -R #{resource.owner}:#{resource.group} #{resource.path}"
  end
end

