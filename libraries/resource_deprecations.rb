module Ark
  class ResourceDeprecations

    def self.on(resource)
      new(resource).warnings
    end

    def initialize(resource)
      @resource = resource
    end

    attr_reader :resource

    def warnings
      applicable_deprecrations.map { |condition,message| message }
    end

    def applicable_deprecrations
      deprecations.find_all { |condition,message| send(condition) }
    end

    def deprecations
      { :strip_leading_dir_feature => strip_leading_dir_feature_message }
    end

    def strip_leading_dir_feature
      [true, false].include?(resource.strip_leading_dir)
    end

    def strip_leading_dir_feature_message
      "strip_leading_dir attribute was deprecated. Use strip_components instead."
    end
  end
end
