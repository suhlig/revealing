# frozen_string_literal: true

require 'aruba/rspec'
require 'helpers/image'

describe 'rake default', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }
  let(:target_file) { project_directory / target_dir / 'index.html' }

  before do
    run_command "#{aruba.root_directory}/exe/revealing init"
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
  end

  shared_examples('default task') do
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

  context 'default target directory' do
    let(:target_dir) { 'public_html' }
    it_behaves_like('default task')
  end

  context 'custom target directory' do
    let(:target_dir) { 'public_html/vorlesung' }

    around do |example|
      old_target_dir = ENV['TARGET_DIR']
      ENV['TARGET_DIR'] = target_dir
      example.run
      ENV['TARGET_DIR'] = old_target_dir
    end

    it_behaves_like('default task')
  end
end
