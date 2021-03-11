# frozen_string_literal: true

require "find"
require "bundler"

Gem::Specification.new do |spec|
  common_gemspec =
      Bundler.load_gemspec_uncached("../common/dependabot-common.gemspec")

  spec.name = "dependabot-runtime_manifest"
  spec.summary = "Runtime manifest support for dependabot"
  spec.version = common_gemspec.version
  spec.description = common_gemspec.description

  spec.author = common_gemspec.author
  spec.email = common_gemspec.email
  spec.homepage = common_gemspec.homepage
  spec.license = common_gemspec.license

  spec.require_path = "lib"
  spec.files = ["lib/dependabot-runtime_manifest.rb",
                "lib/dependabot/runtime_manifest/file_fetcher.rb",
                "lib/dependabot/runtime_manifest/file_parser.rb",
                "lib/dependabot/runtime_manifest/file_updater.rb",
                "lib/dependabot/runtime_manifest/helpers.rb",
                "lib/dependabot/runtime_manifest/metadata_finder.rb",
                "lib/dependabot/runtime_manifest/requirement.rb",
                "lib/dependabot/runtime_manifest/update_checker.rb",
                "lib/dependabot/runtime_manifest/version.rb"]

  spec.required_ruby_version = common_gemspec.required_ruby_version
  spec.required_rubygems_version = common_gemspec.required_ruby_version

  spec.add_dependency "dependabot-common", Dependabot::VERSION

  common_gemspec.development_dependencies.each do |dep|
    spec.add_development_dependency dep.name, dep.requirement.to_s
  end

end