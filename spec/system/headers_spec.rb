# frozen_string_literal: true

require 'aruba/rspec'

describe 'headers', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }
  let(:target_file) { project_directory / 'public_html/index.html' }
  let(:headers) { project_directory / 'headers' }

  before do
    run_command "#{aruba.root_directory}/exe/revealing init"
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }

    headers.mkdir
    FileUtils.cp(fixture('headers/index.markdown'), project_directory / 'src')
    FileUtils.cp(fixture('headers/styles.css'), headers )
    run_command 'bundle exec rake'
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
  end

  it 'includes header content' do
    expect(target_file.read).to include('DarkSlateGrey')
  end

  context 'adding another header file' do
    before do
      expect(target_file.read).not_to include('SlateBlue')
      FileUtils.cp(fixture('headers/more-styles.css'), headers )
    end

    it 'updates the target file' do
      run_command 'bundle exec rake'
      expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
      expect(target_file.read).to include('SlateBlue')
    end
  end

  context 'changing an existing header file' do
    before do
      expect(target_file.read).not_to include('PapayaWhip')
      (project_directory / 'headers/styles.css').write(fixture('headers/styles.css').read.gsub('DarkSlateGrey', 'PapayaWhip'))
    end

    it 'updates the target file' do
      run_command 'bundle exec rake'
      expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
      expect(target_file.read).to include('PapayaWhip')
    end
  end
end
