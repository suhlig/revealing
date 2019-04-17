# frozen_string_literal: true

require 'aruba/rspec'

describe 'doctor', type: 'aruba' do
  context 'all tools are available' do
    it 'prints a success message' do
      run_command "bundle exec #{aruba.root_directory}/exe/revealing doctor"
      expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
      expect(last_command_started).to have_output(/OK/)
    end
  end
end
