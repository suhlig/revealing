require 'thor'
require 'pathname'
require_relative 'prerequisite'

module Revealing
  PREREQUISITES = [
    Prerequisite.new('curl'),
    Prerequisite.new('gm', 'graphicsmagick'),
    Prerequisite.new('gpp'),
    Prerequisite.new('pandoc'),
  ]

  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc 'doctor', 'Checks whether your system is fit for revealing.'
    def doctor
      anything_missing = false
      missing_tools = PREREQUISITES.reject(&:available?)

      if missing_tools.any?
        anything_missing = true
        warn 'Error: The following required tools are not available:'
        missing_tools.each do |tool|
          warn "  * #{tool} - install it with `#{tool.install_hint}`"
        end
      end

      missing_files = target_mapping(TEMPLATES_DIR, Pathname.getwd).values.reject(&:exist?)

      if missing_files.any?
        anything_missing = true
        warn 'Error: The following files do not exist:'
        missing_files.each do |missing|
          warn "  * #{missing.relative_path_from(Pathname.getwd)}"
        end
        warn 'Consider running `revealing init` to create them.'
      end

      exit 1 if anything_missing
    end

    desc 'init [DIRECTORY]', 'initialize a new revealing project in DIRECTORY. Defaults to the current working directory.'
    def init(directory = '.')
      project_directory = Pathname(directory)
      project_directory.mkdir unless project_directory.exist?

      # FileUtils.cp_r overwrites the target if it exists, but we want to preserve it
      # and print information about what happened
      target_mapping(TEMPLATES_DIR, project_directory).each do |src, target|
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

    TEMPLATES_DIR = Pathname(__dir__) / '../../templates/init'

    def target_mapping(src_dir, target_dir)
      src_dir
        .glob('**/*')
        .select(&:file?)
        .map{|f| [f, target_dir / f.relative_path_from(src_dir)]}
        .to_h
    end
  end
end
