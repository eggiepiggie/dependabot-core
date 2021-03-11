
# frozen_string_literal: true

require "dependabot/metadata_finders"
require "dependabot/metadata_finders/base"

module Dependabot
  module RuntimeManifest
    class MetadataFinder < Dependabot::MetadataFinders::Base
      private

      def look_up_source
        nil
      end

    end
  end
end

Dependabot::MetadataFinders.
    register("runtime_manifest", Dependabot::RuntimeManifest::MetadataFinder)