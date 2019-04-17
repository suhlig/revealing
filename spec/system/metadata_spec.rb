# frozen_string_literal: true

require 'aruba/rspec'

describe 'metadata', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }
  let(:target_file) { project_directory / 'public_html/index.html' }
  let(:metadata_file) { project_directory / 'metadata.yml' }

  before do
    run_command "#{aruba.root_directory}/exe/revealing init"
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }

    FileUtils.cp(fixture('metadata/index.markdown'), project_directory / 'src')
    FileUtils.cp(fixture('metadata/metadata.yml'), project_directory)
    run_command 'bundle exec rake'
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
  end

  it 'includes all meta data' do
    expect(target_file.read).to include('de_DE')
  end

  it 'must not copy the metadata file' do
    expect(project_directory / 'public_html/metadata.yml').not_to exist
  end

  context 'adding to the metadata file' do
    before do
      expect(target_file.read).not_to include('revealing')
      (project_directory / 'metadata.yml').open('a') { |f| f.write('- jabberwocky') }
    end

    it 'updates the target file' do
      run_command 'bundle exec rake'
      expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
      expect(target_file.read).to include('jabberwocky')
    end
  end
end
