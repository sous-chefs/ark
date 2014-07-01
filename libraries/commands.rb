
require_relative 'sevenzip_commands'
require_relative 'unzip_commands'
require_relative 'tar_commands'

class GeneralOwner
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    "chown -R #{resource.owner}:#{resource.group} #{resource.path}"
  end
end

class WindowsOwner
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    "icacls #{resource.path}\\* /setowner #{resource.owner}"
  end
end
