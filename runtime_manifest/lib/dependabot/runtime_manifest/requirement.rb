# frozen_string_literal: true

require "dependabot/utils"

module Dependabot
  module RuntimeManifest
    class Requirement < Gem::Requirement
    end
  end
end

Dependabot::Utils.
    register_requirement_class("runtime_manifest", Dependabot::RuntimeManifest::Requirement)