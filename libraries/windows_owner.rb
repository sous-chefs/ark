module Ark
  class WindowsOwner
    def initialize(resource)
      @resource = resource
    end

    attr_reader :resource

    def command
      "#{ENV.fetch('SystemRoot')}\\System32\\icacls \"#{resource._deploy_path}\\*\" /setowner \"#{resource.owner}\""
    end
  end
end
