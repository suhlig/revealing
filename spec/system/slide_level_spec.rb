# frozen_string_literal: true

require 'aruba/rspec'
require 'nokogiri'
require 'rspec/collection_matchers'

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

  shared_examples 'horizontal slide content' do
    it 'has the heading of the first horizontal slide' do
      expect(target_file.read).to include('Horizontal 1')
    end

    it 'has the heading of the second horizontal slide' do
      expect(target_file.read).to include('Horizontal 2')
    end
  end

  shared_examples 'vertical slide content' do
    it 'has the content of the first vertical slide' do
      expect(target_file.read).to include('Vertical 1')
    end

    it 'has the content of the second vertical slide' do
      expect(target_file.read).to include('Vertical 2')
    end
  end

  context 'default slide level' do
    it_behaves_like('horizontal slide content')
    it_behaves_like('vertical slide content')
  end

  context 'slide level set to 1' do
    around do |example|
      old_slide_level = ENV['REVEAL_JS_SLIDE_LEVEL']
      ENV['REVEAL_JS_SLIDE_LEVEL'] = '1'
      example.run
      ENV['REVEAL_JS_SLIDE_LEVEL'] = old_slide_level
    end

    it_behaves_like('horizontal slide content')
    it_behaves_like('vertical slide content')

    describe 'one-dimensional slide structure' do
      it 'has two top-level sections' do
        sections = Nokogiri::HTML(target_file.read).css('section')
        expect(sections).to have_exactly(2).items
      end

      it 'has no nested sections' do
        sections = Nokogiri::HTML(target_file.read).css('section > section')
        expect(sections).to have_exactly(0).items
      end
    end
  end

  context 'slide level set to 2' do
    around do |example|
      old_slide_level = ENV['REVEAL_JS_SLIDE_LEVEL']
      ENV['REVEAL_JS_SLIDE_LEVEL'] = '2'
      example.run
      ENV['REVEAL_JS_SLIDE_LEVEL'] = old_slide_level
    end

    it_behaves_like('horizontal slide content')
    it_behaves_like('vertical slide content')

    describe 'two-dimensional slide structure' do
      it 'has two top-level sections with two sections each' do
        sections = Nokogiri::HTML(target_file.read).css('section')
        expect(sections).to have_exactly(6).items
      end

      it 'has four nested sections' do
        sections = Nokogiri::HTML(target_file.read).css('section > section')
        expect(sections).to have_exactly(4).items
      end
    end
  end
end
