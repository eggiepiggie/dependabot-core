# frozen_string_literal: true

require "dependabot/pull_request_updater/github"
require "dependabot/pull_request_updater/gitlab"

module Dependabot
  class PullRequestUpdater
    class BranchProtected < StandardError; end

    attr_reader :source, :files, :base_commit, :old_commit, :credentials,
                :pull_request_number, :author_details, :signature_key

    def initialize(source:, base_commit:, old_commit:, files:,
                   credentials:, pull_request_number:,
                   author_details: nil, signature_key: nil)
      @source              = source
      @base_commit         = base_commit
      @old_commit          = old_commit
      @files               = files
      @credentials         = credentials
      @pull_request_number = pull_request_number
      @author_details      = author_details
      @signature_key       = signature_key
    end

    def update
      case source.provider
      when "github" then github_updater.update
      when "gitlab" then gitlab_updater.update
      when "azure" then azure_updater.update
      else raise "Unsupported provider #{source.provider}"
      end
    end

    private

    def github_updater
      Github.new(
        source: source,
        base_commit: base_commit,
        old_commit: old_commit,
        files: files,
        credentials: credentials,
        pull_request_number: pull_request_number,
        author_details: author_details,
        signature_key: signature_key
      )
    end

    def gitlab_updater
      Gitlab.new(
        source: source,
        base_commit: base_commit,
        old_commit: old_commit,
        files: files,
        credentials: credentials,
        pull_request_number: pull_request_number
      )
    end

    def azure_updater
      Azure.new(
        source: source,
        base_commit: base_commit,
        old_commit: old_commit,
        files: files,
        credentials: credentials,
        pull_request_number: pull_request_number
      )
    end
  end
end
