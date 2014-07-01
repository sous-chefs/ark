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

class UnzipDumper
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    "unzip  -j -q -u -o \"#{resource.release_file}\" -d \"#{resource.path}\""
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
