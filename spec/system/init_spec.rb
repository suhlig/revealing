# frozen_string_literal: true

require 'aruba/rspec'

describe 'init', type: 'aruba' do
  let(:revealing_init) { "#{aruba.root_directory}/exe/revealing init" }
  let(:cwd) { Pathname(aruba.config.working_directory) }
  let(:project_directory) { cwd / 'shiny-new-presentation' }
  let(:project_files) { %w[src/index.markdown headers/mathjax.js Rakefile Gemfile README.markdown metadata.yml].map { |e| project_directory / e } }

  shared_examples 'a new project directory' do
    it 'creates the required files in the new project directory' do
      run_command "#{revealing_init} #{project_directory.basename}"
      expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
      expect(project_files).to all(exist)
    end
  end

  context 'with a new project directory' do
    it 'creates the new project directory' do
      run_command "#{revealing_init} #{project_directory.basename}"
      expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
      expect(project_directory).to be_directory
    end

    it_behaves_like('a new project directory')
  end

  context 'with an existing (empty) project directory' do
    before do
      project_directory.mkdir
      expect(project_directory).to be_directory
    end

    it_behaves_like('a new project directory')

    context 'the README already exists' do
      let(:readme) { (project_directory / 'README.markdown') }

      before do
        readme.write('fooo')
      end

      it 'does not override an existing file' do
        run_command "#{revealing_init} #{project_directory.basename}"
        expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
        expect(readme.read).to eq('fooo')
      end
    end
  end

  context 'with the current working directory as project directory' do
    let(:project_directory) { cwd }

    it 'creates the required files in the current working directory' do
      run_command "#{revealing_init}"
      expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
      expect(project_files).to all(exist)
    end
  end
end
