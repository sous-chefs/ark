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

class TarUnpacker
  def initialize(resource,options = {})
    @resource = resource
    @options = options
  end

  attr_reader :resource, :options

  def command
    tar_command(options[:flags])
  end

  def node
    resource.run_context.node
  end

  def tar_command(tar_args)
    cmd = node['ark']['tar']
    cmd += " #{tar_args} "
    cmd += resource.release_file
    cmd += tar_strip_args
    cmd
  end

  def tar_strip_args
    resource.strip_components > 0 ? " --strip-components=#{resource.strip_components}" : ""
  end
end

class UnzipUnpacker
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    unzip_command
  end

  def unzip_command
    if resource.strip_components > 0
      require 'tmpdir'
      tmpdir = Dir.mktmpdir
      strip_dir = '*/' * resource.strip_components
      cmd = "unzip -q -u -o #{resource.release_file} -d #{tmpdir}"
      cmd += " && rsync -a #{tmpdir}/#{strip_dir} #{resource.path}"
      cmd += " && rm -rf #{tmpdir}"
      cmd
    else
      "unzip -q -u -o #{resource.release_file} -d #{resource.path}"
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

class TarDumper
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    "tar -mxf \"#{resource.release_file}\" -C \"#{resource.path}\""
  end
end

class UnzipDumper
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    "unzip  -j -q -u -o \"#{resource.release_file}\" -d \"#{resource.path}\""
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

class TarCherryPicker
  def initialize(resource, options={})
    @resource = resource
    @options = options
  end

  attr_reader :resource, :options

  def command
    cherry_pick_tar_command(options[:flags])
  end

  def node
    resource.run_context.node
  end

  def cherry_pick_tar_command(tar_args)
    cmd = node['ark']['tar']
    cmd += " #{tar_args}"
    cmd += " #{resource.release_file}"
    cmd += " -C"
    cmd += " #{resource.path}"
    cmd += " #{resource.creates}"
    cmd += tar_strip_args
    cmd
  end

  # private
  def tar_strip_args
    resource.strip_components > 0 ? " --strip-components=#{resource.strip_components}" : ""
  end

end

class UnzipCherryPicker
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def cherry_pick_unzip_command
    cmd = "unzip -t #{resource.release_file} \"*/#{resource.creates}\" ; stat=$? ;"
    cmd += "if [ $stat -eq 11 ] ; then "
    cmd += "unzip  -j -o #{resource.release_file} \"#{resource.creates}\" -d #{resource.path} ;"
    cmd += "elif [ $stat -ne 0 ] ; then false ;"
    cmd += "else "
    cmd += "unzip  -j -o #{resource.release_file} \"*/#{resource.creates}\" -d #{resource.path} ;"
    cmd += "fi"
    cmd
  end

  def command
    cherry_pick_unzip_command
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

class GeneralOwner
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    "chown -R #{resource.owner}:#{resource.group} #{resource.path}"
  end
end

class UnzipUnzipper
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    if resource.strip_components > 0
      command_with_components_stripped
    else
      "unzip -q -u -o #{resource.release_file} -d #{resource.path}"
    end
  end

  def command_with_components_stripped
    require 'tmpdir'
    tmpdir = Dir.mktmpdir
    strip_dir = '*/' * resource.strip_components
    cmd = "unzip -q -u -o #{resource.release_file} -d #{tmpdir}"
    cmd += " && rsync -a #{tmpdir}/#{strip_dir} #{resource.path}"
    cmd += " && rm -rf #{tmpdir}"
    cmd
  end

end
