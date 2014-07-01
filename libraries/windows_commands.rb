
class WindowsUnpacker
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    sevenzip_command
  end

  def sevenzip_command
    if resource.strip_components <= 0
      sevenzip_command_builder(resource.path, 'x')
      return
    end

    require 'tmpdir'
    tmpdir = Dir.mktmpdir
    cmd = sevenzip_command_builder(tmpdir, 'e')

    cmd += " && "
    currdir = tmpdir.gsub('/', '\\')

    1.upto(resource.strip_components).each do |count|
      cmd += "for /f %#{count} in ('dir /ad /b \"#{currdir}\"') do "
      currdir += "\\%#{count}"
    end

    cmd += "xcopy \"#{currdir}\" \"#{resource.home_dir}\" /s /e"
  end

  def sevenzip_binary
    resource.run_context.node['ark']['tar']
  end

  def sevenzip_command_builder(dir, command)
    "#{sevenzip_binary} #{command} \"#{resource.release_file}\"#{extension_is_tar} -o\"#{dir}\" -uy"
  end

  def extension_is_tar
    if resource.extension =~ /tar.gz|tgz|tar.bz2|tbz|tar.xz|txz/
      " -so | #{sevenzip_binary} x -aoa -si -ttar"
    else
      ""
    end
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
