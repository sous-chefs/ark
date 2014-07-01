
class TarCommandBuilder

  def unpack
    "#{tar_binary} #{args} #{resource.release_file} #{strip_args}"
  end

  def dump
    "tar -mxf \"#{resource.release_file}\" -C \"#{resource.path}\""
  end

  def cherry_pick
    "#{tar_binary} #{args} #{resource.release_file} -C #{resource.path} #{resource.creates}#{strip_args}"
  end

  def initialize(resource, options = {})
    @resource = resource
    @options = options
  end

  private

  attr_reader :resource, :options

  def node
    resource.run_context.node
  end

  def tar_binary
    resource.run_context.node['ark']['tar']
  end

  def args
    options[:flags]
  end

  def strip_args
    resource.strip_components > 0 ? " --strip-components=#{resource.strip_components}" : ""
  end

end