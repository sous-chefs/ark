
class WindowsUnpacker
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    sevenzip_command
  end

  def sevenzip_command
    if resource.strip_components > 0
      require 'tmpdir'
      tmpdir = Dir.mktmpdir
      cmd = sevenzip_command_builder(tmpdir, 'e')
      cmd += " && "
      currdir = tmpdir
      var = 0
      while var < resource.strip_components
        var += 1
        cmd += "for /f %#{var} in ('dir /ad /b \"#{currdir.gsub! '/', '\\'}\"') do "
        currdir += "\\%#{var}"
      end
      cmd += "xcopy \"#{currdir}\" \"#{resource.home_dir}\" /s /e"
    else
      cmd = sevenzip_command_builder(resource.path, 'x')
    end
    cmd
  end

  def node
    resource.run_context.node
  end

  def sevenzip_command_builder(dir, command)
    cmd = "#{node['ark']['tar']} #{command} \""
    cmd += resource.release_file
    cmd += "\" "
    case resource.extension
    when /tar.gz|tgz|tar.bz2|tbz|tar.xz|txz/
      cmd += " -so | #{node['ark']['tar']} x -aoa -si -ttar"
    end
    cmd += " -o\"#{dir}\" -uy"
    cmd
  end
end

class WindowsDumper
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    sevenzip_command_builder(resource.path, 'e')
  end

  def node
    resource.run_context.node
  end

  def sevenzip_command_builder(dir, command)
    cmd = "#{node['ark']['tar']} #{command} \""
    cmd += resource.release_file
    cmd += "\" "
    case resource.extension
    when /tar.gz|tgz|tar.bz2|tbz|tar.xz|txz/
      cmd += " -so | #{node['ark']['tar']} x -aoa -si -ttar"
    end
    cmd += " -o\"#{dir}\" -uy"
    cmd
  end

end

class WindowsCherryPicker
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    "#{sevenzip_command_builder(resource.path, 'e')} -r #{resource.creates}"
  end

  def node
    resource.run_context.node
  end

  def sevenzip_command_builder(dir, command)
    cmd = "#{node['ark']['tar']} #{command} \""
    cmd += resource.release_file
    cmd += "\" "
    case resource.extension
    when /tar.gz|tgz|tar.bz2|tbz|tar.xz|txz/
      cmd += " -so | #{node['ark']['tar']} x -aoa -si -ttar"
    end
    cmd += " -o\"#{dir}\" -uy"
    cmd
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
