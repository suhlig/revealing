require 'thor'
require 'pathname'

module Revealing
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc 'init [DIRECTORY]', 'initialize a new revealing project in DIRECTORY. Defaults to the current working directory.'
    def init(directory = '.')
      project_directory = Pathname(directory)
      project_directory.mkdir unless project_directory.exist?

      templates_directory = Pathname(__dir__) / '../../templates/init'

      # FileUtils.cp_r overwrites the target if it exists, but we want to preserve it
      # and print information about what happened
      source_target_pairs(templates_directory, project_directory).each do |src, target|
        if target.exist?
          warn "#{target} exists; skipping"
        else
          target.dirname.mkpath
          FileUtils.cp(src, target)
          puts "#{target} created"
        end
      end
    end

    private

    def source_target_pairs(src_dir, target_dir)
      src_dir
        .glob('**/*')
        .select(&:file?)
        .map{|e| [e, target_dir / e.relative_path_from(src_dir)]}
    end
  end
end
