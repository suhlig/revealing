# frozen_string_literal: true

require 'aruba/rspec'

describe 'slide-level', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }
  let(:target_file) { project_directory / 'public_html/index.html' }

  before do
    run_command "#{aruba.root_directory}/exe/revealing init"
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }

    FileUtils.cp_r(fixture('slide-level').glob('*'), project_directory / 'src')
    run_command 'bundle exec rake'
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
  end

  shared_examples('slide level 1') do
    it 'has the heading of the first slide' do
      expect(target_file.read).to include('Title: Overview')
    end

    it 'has the content of the first slide' do
      expect(target_file.read).to include('content of overview')
    end

    it 'has the heading of the second slide' do
      expect(target_file.read).to include('Title: Details')
    end

    it 'has the content of the second slide' do
      expect(target_file.read).to include('content of details')
    end
  end

  context 'default slide level' do
    it_behaves_like('slide level 1')
  end

  context 'slide level set to 1' do
    around do |example|
      old_slide_level = ENV['REVEAL_JS_SLIDE_LEVEL']
      ENV['REVEAL_JS_SLIDE_LEVEL'] = '1'
      example.run
      ENV['REVEAL_JS_SLIDE_LEVEL'] = old_slide_level
    end

    it_behaves_like('slide level 1')
  end

  context 'slide level set to 2' do
    around do |example|
      old_slide_level = ENV['REVEAL_JS_SLIDE_LEVEL']
      ENV['REVEAL_JS_SLIDE_LEVEL'] = '2'
      example.run
      ENV['REVEAL_JS_SLIDE_LEVEL'] = old_slide_level
    end

    it 'has the heading of the first slide' do
      expect(target_file.read).to include('Title: Overview')
    end

    it 'does NOT have the content of the first slide' do
      expect(target_file.read).to_not include('content of overview')
    end

    it 'has the heading of the second slide' do
      expect(target_file.read).to include('Title: Details')
    end

    it 'does NOT have the content of the second slide' do
      expect(target_file.read).to_not include('content of details')
    end
  end
end
