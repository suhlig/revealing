require 'thor'
require 'pathname'
require_relative 'prerequisite'

module Revealing
  PREREQUISITES = [
    Prerequisite.new('curl'),
    Prerequisite.new('java'),
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

      missing_files = target_files_in(Pathname.getwd).reject(&:exist?)

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
      template_files.zip(target_files_in(project_directory)).each do |src, target|
        if target.exist?
          warn "#{target} exists; skipping"
        else
          target.dirname.mkpath
          FileUtils.cp(src, target)
          puts "#{target} created"
        end
      end
    end

    desc 'version', 'Prints version information'
    def version
      puts "revealing #{Revealing::VERSION}"
    end
    map %w(-V --version) => :version

    private

    TEMPLATES_DIR = Pathname(__dir__) / '../../templates'

    def template_files
      TEMPLATES_DIR.glob('**/*').select(&:file?)
    end

    def target_files_in(dir)
      template_files.map{|f| dir / f.relative_path_from(TEMPLATES_DIR)}
    end
  end
end
