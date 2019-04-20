# frozen_string_literal: true

require 'aruba/rspec'

describe 'ditaa', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }
  let(:target_file) { project_directory / 'public_html/index.html' }

  before do
    run_command "#{aruba.root_directory}/exe/revealing init"
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }

    FileUtils.cp_r(fixture('ditaa').glob('*'), project_directory / 'src')
    run_command 'bundle exec rake'
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
  end

  it 'includes the drawing as SVG' do
    expect(target_file.read).to include('<svg')
  end
end
