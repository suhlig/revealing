# frozen_string_literal: true

require 'aruba/rspec'

describe 'init', type: 'aruba' do
  let(:revealing_init) { "#{aruba.root_directory}/exe/revealing init" }

  context 'with a new project directory' do
    let(:project_directory) { 'shiny-new-presentation' }
    let(:cwd) { Pathname(aruba.config.working_directory) }

    before do
      run_command "#{revealing_init} #{project_directory}"
      expect(last_command_started).to be_successfully_executed
    end

    it 'creates the new project directory' do
      expect(cwd / project_directory).to be_directory
    end

    it 'creates the required files in the new project directory' do
      expect(cwd / project_directory / 'src/index.markdown').to exist
      expect(cwd / project_directory / 'Rakefile').to exist
      expect(cwd / project_directory / 'Gemfile').to exist
      expect(cwd / project_directory / 'README.markdown').to exist
    end
  end
end
