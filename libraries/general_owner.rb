module Ark
  class GeneralOwner
    def initialize(resource)
      @resource = resource
    end

    attr_reader :resource

    def command
      "chown -R #{resource.owner}:#{resource.group} #{resource._deploy_path}"
    end
  end
end
