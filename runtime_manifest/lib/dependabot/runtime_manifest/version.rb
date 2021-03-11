# frozen_string_literal: true

require "dependabot/utils"

module Dependabot
  module RuntimeManifest
    class Version < Gem::Version
    end
  end
end

Dependabot::Utils.
    register_version_class("runtime_manifest", Dependabot::RuntimeManifest::Version)