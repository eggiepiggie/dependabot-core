require "dependabot/dependency"
require "dependabot/file_parsers"
require "dependabot/file_parsers/base"
require "dependabot/shared_helpers"
require "dependabot/errors"
require "yaml"
require "dependabot/file_parsers/base/dependency_set"

module Dependabot
  module RuntimeManifest
    class FileParser < Dependabot::FileParsers::Base
      def parse
        dependency_set = DependencySet.new
        dependency_set += kiln_dependencies
        dependency_set.dependencies
      end

      private

      def check_required_files
        raise "No manifest.yaml!" unless runtime_manifest
        raise "No manifest.yaml.lock!" unless lockfile
      end

      def runtime_manifest
        @runtime_manifest ||= get_original_file("manifest.yaml")
      end

      def lockfile
        @lockfile ||= get_original_file("manifest.yaml.lock")
      end

      def manifest_dependencies
        dependencies = DependencySet.new

        runtime_manifest ||= get_original_file("manifest.yaml")
        lockfile ||= get_original_file("manifest.yaml.lock")

        manifest_contents = YAML.load(runtime_manifest.content)["components"]
        lockfile_contents = YAML.load(lockfile.content)["apiVersion"]

        # Ensure component can be found in the lockfile.
        # manifest_contents.each_with_index do |manifest_content, index|
        #   lockfile_content = lockfile_contents.find { |release| release["name"] == kilnfile_content["name"] }

        #   if lockfile_content.nil?
        #     raise "The release '#{kilnfile_content["name"]}' does not match any release in Kilnfile.lock"
        #   end

        #   dependencies << Dependency.new(
        #       name: kilnfile_content["name"],
        #       requirements: [{
        #                          requirement: kilnfile_content["version"],
        #                          file: kilnfile.name,
        #                          groups: [:default],
        #                          source: {
        #                              type: lockfile_content["remote_source"],
        #                              remote_path: lockfile_content["remote_path"],
        #                              sha: lockfile_content["sha1"],
        #                          },
        #                      }],
        #       version: lockfile_content["version"],
        #       package_manager: "kiln"
        #   )
        # end
        dependencies
      end
    end
  end
end
Dependabot::FileParsers.register("runtime_manifest", Dependabot::RuntimeManifest::FileParser)