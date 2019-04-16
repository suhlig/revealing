# frozen_string_literal: true

require 'aruba/rspec'
require 'helpers/image'

describe 'calling rake', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }
  let(:target_file) { project_directory / 'public_html/index.html' }

  before do
    run_command "#{aruba.root_directory}/exe/revealing init"
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
  end

  it 'creates the target file' do
    run_command 'bundle exec rake'
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
    expect(target_file).to be_file
  end

  context 'updating the source' do
    let(:source_file) { project_directory / 'src/index.markdown' }

    before do
      expect(source_file.read).not_to include('appended slide')
      source_file.open('a') { |f| f.write('# appended slide') }
    end

    it 'updates the target file' do
      run_command 'bundle exec rake'
      expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
      expect(target_file.read).to include('appended slide')
    end
  end

  context 'running it twice' do
    before do
      run_command 'bundle exec rake'
      expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
      expect(last_command_started.stderr).to_not be_empty
    end

    it 'does not trigger execution again' do
      run_command 'bundle exec rake'
      expect(last_command_started.stderr).to be_empty
    end
  end
end
