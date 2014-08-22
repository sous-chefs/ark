module Ark
  class GeneralOwner
    def initialize(resource)
      @resource = resource
    end

    attr_reader :resource

    def command
      if resource.do_not_chown_wildcard
        "find #{resource.path} -path '#{resource.do_not_chown_wildcard}' -prune -o -exec chown #{resource.owner}:#{resource.group} {} \\;"
      else
        "chown -R #{resource.owner}:#{resource.group} #{resource.path}"
      end
    end
  end
end
