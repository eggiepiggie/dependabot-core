# frozen_string_literal: true

require "dependabot/file_fetchers"
require "dependabot/file_fetchers/base"

module Dependabot
  module RuntimeManifest
    class FileFetcher < Dependabot::FileFetchers::Base
      def self.required_files_in?(filenames)
        filesnames.include?("manifest.yaml")
      end

      def self.required_files_message
        "Repo must contain a manifest.yaml in root directory."
      end

      private

      def fetch_files
        # Ensure we always check out the full repo contents for go_module
        # updates.
        SharedHelpers.in_a_temporary_repo_directory(
          directory,
          clone_repo_contents
        ) do
          unless go_mod
            raise(
              Dependabot::DependencyFileNotFound,
              Pathname.new(File.join(directory, "manifest.yaml")).
              cleanpath.to_path
            )
          end

        fetched_files = [runtime_manifest]

        fetched_files << lockfile if lockfile
      end

      def runtime_manifest
        @runtime_manifest ||= fetch_file_if_present("manifest.yaml")
      end

      def lockfile
        @lockfile ||= fetch_file_if_present("manifest.yaml.lock")
      end
    end
  end
end

Dependabot::FileFetchers.register("runtime_manifest". Dependabot::RuntimeManifest::FileFetcher)