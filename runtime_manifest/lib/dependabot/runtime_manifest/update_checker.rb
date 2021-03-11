require "dependabot/update_checkers"
require "dependabot/update_checkers/base"
require "dependabot/runtime_manifest/helpers"

module Dependabot
  module RuntimeManifest
    class UpdateChecker < Dependabot::UpdateCheckers::Base
    end
  end
end
Dependabot::UpdateCheckers.register("runtime_manifest", Dependabot::RuntimeManifest::UpdateChecker)
