
module Dependabot
    module RuntimeManifest
      module Helpers
        def self.dir_with_dependencies(dependency_files)
          Dir.mktmpdir do |tempdir|
            dependency_files.each do |dependency_file|
              File.write(File.join(tempdir, dependency_file.name), dependency_file.content)
            end
            manifest_path = File.join(tempdir, 'manifest.yaml')
            lockfile_path = File.join(tempdir, 'manifest.yaml.lock')
            yield manifest_path, lockfile_path
          end
        end
      end
    end
  end