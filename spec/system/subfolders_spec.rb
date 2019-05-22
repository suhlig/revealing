# frozen_string_literal: true

require 'aruba/rspec'
require 'helpers/image'

describe 'subfolders', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }
  let(:target_file) { project_directory / 'public_html/index.html' }

  before do
    run_command "#{aruba.root_directory}/exe/revealing init"
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }

    FileUtils.cp_r(fixture('subfolders').glob('*'), project_directory / 'src')
    run_command 'bundle exec rake'
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
  end

  it 'includes content from the `cat` subfolder' do
    expect(target_file.read).to include('Dimitris Vetsikas')
    expect(project_directory / 'public_html/cat-1608581.jpg').to be_file
  end

  it 'includes content from the `dog` subfolder' do
    expect(target_file.read).to include('Tom und Nicki Löschner')
    expect(project_directory / 'public_html/dog-1551709.jpg').to be_file
  end
end
