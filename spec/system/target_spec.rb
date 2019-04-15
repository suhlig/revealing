# frozen_string_literal: true

require 'aruba/rspec'
require 'helpers/image'

describe 'calling rake', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }

  before do
    run_command "#{aruba.root_directory}/exe/revealing init"
    expect(last_command_started).to be_successfully_executed
  end

  it 'creates the target file' do
    run_command 'bundle exec rake'
    expect(last_command_started).to be_successfully_executed
    expect(project_directory / 'public_html/index.html').to be_file
  end
end
