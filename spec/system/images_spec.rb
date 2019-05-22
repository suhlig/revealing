# frozen_string_literal: true

require 'aruba/rspec'
require 'helpers/image'

describe 'images', type: 'aruba' do
  let(:project_directory) { Pathname(aruba.config.working_directory) }
  let(:target_file) { project_directory / 'public_html/index.html' }

  before do
    run_command "#{aruba.root_directory}/exe/revealing init"
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }

    FileUtils.cp_r(fixture('images').glob('*'), project_directory / 'src')
    run_command 'bundle exec rake'
    expect(last_command_started).to be_successfully_executed, lambda { last_command_started.output }
  end

  it 'handles images with spaces in the file name' do
    expect(project_directory / 'public_html/a mouse.jpg').to exist
  end

  it 'resizes images to not be wider than 1920px' do
    expect(Image.new(project_directory / 'public_html/cat-1608581.jpg').width).to be <= 1920
    expect(Image.new(project_directory / 'public_html/dog-1551709.jpg').width).to be <= 1920
  end

  it 'resizes images to not be taller than 1080px' do
    expect(Image.new(project_directory / 'public_html/cat-1608581.jpg').height).to be <= 1080
    expect(Image.new(project_directory / 'public_html/dog-1551709.jpg').height).to be <= 1080
  end
end
