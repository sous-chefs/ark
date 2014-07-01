
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

class TarDumper
  def initialize(resource)
    @resource = resource
  end

  attr_reader :resource

  def command
    "tar -mxf \"#{resource.release_file}\" -C \"#{resource.path}\""
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
