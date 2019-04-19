# frozen_string_literal: true

require 'aruba/rspec'

describe 'version', type: 'aruba' do
  shared_examples('version printed') do
    it 'prints program name and version information' do
      run_command "bundle exec #{aruba.root_directory}/exe/revealing #{option}"
      expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
      expect(last_command_started).to have_output(%r{revealing \d\.\d\.\d})
    end
  end

    context 'version' do
      let(:option) { 'version' }
      it_behaves_like('version printed')
    end

    context '--version' do
      let(:option) { '--version' }
      it_behaves_like('version printed')
    end

    context '-V' do
      let(:option) { '-V' }
      it_behaves_like('version printed')
    end
end
