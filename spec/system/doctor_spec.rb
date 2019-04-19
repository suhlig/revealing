# frozen_string_literal: true

require 'aruba/rspec'

describe 'doctor', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }

  before do
    run_command "#{aruba.root_directory}/exe/revealing init"
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
  end

  it 'prints a success message' do
    run_command "bundle exec #{aruba.root_directory}/exe/revealing doctor"
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
  end

  context 'a required project file is missing' do
    before do
      (project_directory / 'src/index.markdown').delete
    end

    it 'prints an error message' do
      run_command "bundle exec #{aruba.root_directory}/exe/revealing doctor"
      expect(last_command_started).to_not be_successfully_executed, lambda { last_command_started.output }
      expect(last_command_started).to have_output(%r{ src/index.markdown})
    end
  end
end
