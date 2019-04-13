require 'thor'

module Revealing
  class CLI < Thor
    desc 'init DIRECTORY', "initialize a new revealing project in DIRECTORY."
    def init(directory)
      project_directory = Pathname(directory)
      project_directory.mkdir

      templates_directory = Pathname(__dir__) / '../../templates'
      FileUtils.cp_r(templates_directory / 'init/.', project_directory)
    end
  end
end
