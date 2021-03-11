# This script is designed to loop through all dependencies in a GHE, GitLab or
# Azure DevOps project, creating PRs where necessary.

require "dependabot-runtime-manifest"

# Full name of the repo you want to create pull requests for.
repo_name = "Shopify/eggie-rails-test-app"
repo_branch = "master"

credentials = [
    {
        "type" => "git_source",
        "host" => "github.com",
        "username" => "x-access-token",
        "password" => ENV["GITHUB_RELENG_CI_BOT_PERSONAL_ACCESS_TOKEN"] # A GitHub access token with read access to public repos
    },
    {
        "type" => "runtime_manifest"
    }
]


# Directory where the base dependency files are.
directory = "/"

# Name of the package manager you'd like to do the update for. Options are:
package_manager = "runtime_manifest"


source = Dependabot::Source.new(
    provider: "github",
    repo: repo_name,
    directory: directory,
    branch: repo_branch
)

##############################
# Fetch the dependency files #
##############################
puts "Fetching #{package_manager} dependency files for #{repo_name}"
fetcher = Dependabot::FileFetchers.for_package_manager(package_manager).new(
    source: source,
    credentials: credentials
)

files = fetcher.files
commit = fetcher.commit

##############################
# Parse the dependency files #
##############################
puts "Parsing dependencies information"
parser = Dependabot::FileParsers.for_package_manager(package_manager).new(
    dependency_files: files,
    source: source,
    credentials: credentials,
)

dependencies = parser.parse
dependencies.select(&:top_level?).each do |dep|
  #########################################
  # Get update details for the dependency #
  #########################################
  checker = Dependabot::UpdateCheckers.for_package_manager(package_manager).new(
      dependency: dep,
      dependency_files: files,
      credentials: credentials,
  )

  updated_deps = checker.updated_dependencies(
      requirements_to_unlock: :own
  )

  #####################################
  # Generate updated dependency files #
  #####################################
  if updated_deps == []
    puts "Nothing to update for #{dep.name}. Bailing out early!"
    next
  end

  print "  - Updating #{dep.name} (from #{dep.version})…"
  updater = Dependabot::FileUpdaters.for_package_manager(package_manager).new(
      dependencies: updated_deps,
      dependency_files: files,
      credentials: credentials,
  )

  updated_files = updater.updated_dependency_files

  ########################################
  # Create a pull request for the update #
  ########################################
  pr_creator = Dependabot::PullRequestCreator.new(
      source: source,
      base_commit: commit,
      dependencies: updated_deps,
      files: updated_files,
      credentials: credentials
  )
  pull_request = pr_creator.create
  puts " submitted"

  # next unless pull_request

  # Enable GitLab "merge when pipeline succeeds" feature.
  # Merge requests created and successfully tested will be merge automatically.
  # if ENV["GITLAB_AUTO_MERGE"]
  #   g = Gitlab.client(
  #       endpoint: source.api_endpoint,
  #       private_token: ENV["GITLAB_ACCESS_TOKEN"]
  #   )
  #   g.accept_merge_request(
  #       source.repo,
  #       pull_request.iid,
  #       merge_when_pipeline_succeeds: true,
  #       should_remove_source_branch: true
  #   )
  # end
end