# frozen_string_literal: true

require 'aruba/rspec'

describe 'duplicate assets', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }

  context 'generic assets' do
    before do
      run_command "#{aruba.root_directory}/exe/revealing init"
      expect(last_command_started).to be_successfully_executed
      FileUtils.cp_r(fixture('duplicate-generic-assets').glob('*'), project_directory / 'src')
    end

    it 'refuses to override duplicates' do
      run_command 'bundle exec rake'
      expect(last_command_started).to_not be_successfully_executed
    end
  end

  context 'resizable assets' do
    before do
      run_command "#{aruba.root_directory}/exe/revealing init"
      expect(last_command_started).to be_successfully_executed
      FileUtils.cp_r(fixture('duplicate-resizable-assets').glob('*'), project_directory / 'src')
    end

    it 'refuses to override duplicates' do
      run_command 'bundle exec rake'
      expect(last_command_started).to_not be_successfully_executed
    end
  end
end
