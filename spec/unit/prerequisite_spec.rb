# frozen_string_literal: true

require 'revealing/prerequisite'

describe Revealing::Prerequisite do
  let(:binary) { 'some-tool' }

  context 'the binary is NOT in the PATH' do
    subject(:prereq) { described_class.new(binary) }

    it 'says that it is available' do
      expect(subject.available?).to be_falsy
    end
  end

  context 'the binary is in the PATH' do
    around do |example|
      original_path = ENV['PATH']
      ENV['PATH'] = [fixture('prerequisite').to_path, '/bin'].join(':')
      example.run
      ENV['PATH'] = original_path
    end

    shared_examples('a prerequisite') do
      it 'has a command' do
        expect(subject.command).to eq(binary)
      end

      it 'has a string representation' do
        expect(subject.to_s).to eq(binary)
      end

      it 'says that it is available' do
        expect(subject.available?).to be_truthy
      end
    end

    context 'the package is named like the command' do
      subject(:prereq) { described_class.new(binary) }

      it_behaves_like('a prerequisite')

      context 'os-dependant' do
        before do
          allow(Gem::Platform).to receive_message_chain(:local, :os).and_return(platform)
        end

        context 'on OSX' do
          let(:platform) { 'darwin' }

          it 'provides an install hint' do
            expect(subject.install_hint).to include("brew install #{binary}")
          end
        end

        context 'on Linux' do
          let(:platform) { 'linux' }

          it 'provides an install hint' do
            expect(subject.install_hint).to include("apt install #{binary}")
          end
        end
      end
    end

    context 'the package name differs from the command name' do
      subject(:prereq) { described_class.new(binary, 'tool-package') }

      it_behaves_like('a prerequisite')

      context 'os-dependant' do
        before do
          allow(Gem::Platform).to receive_message_chain(:local, :os).and_return(platform)
        end

        context 'on OSX' do
          let(:platform) { 'darwin' }

          it 'provides an install hint' do
            expect(subject.install_hint).to include("brew install tool-package")
          end
        end

        context 'on Linux' do
          let(:platform) { 'linux' }

          it 'provides an install hint' do
            expect(subject.install_hint).to include("apt install tool-package")
          end
        end
      end
    end

    context 'the package name differs between Linux and MacOS' do
      subject(:prereq) { described_class.new(binary, darwin: 'foo-package', linux: 'bar-package') }

      it_behaves_like('a prerequisite')

      context 'os-dependant' do
        before do
          allow(Gem::Platform).to receive_message_chain(:local, :os).and_return(platform)
        end

        context 'on OSX' do
          let(:platform) { 'darwin' }

          it 'provides an install hint' do
            expect(subject.install_hint).to include("brew install foo-package")
          end
        end

        context 'on Linux' do
          let(:platform) { 'linux' }

          it 'provides an install hint' do
            expect(subject.install_hint).to include("apt install bar-package")
          end
        end
      end
    end

    context 'the package is provided as block' do
      subject(:prereq) {
        described_class.new(binary, lambda { |platform|
          "curl http://example.com/#{platform}/lambda > /usr/local/bin/lambda"
        })
      }

      it_behaves_like('a prerequisite')

      context 'os-dependant' do
        before do
          allow(Gem::Platform).to receive_message_chain(:local, :os).and_return(platform)
        end

        context 'on OSX' do
          let(:platform) { 'darwin' }

          it 'provides an install hint' do
            expect(subject.install_hint).to include("http://example.com/darwin/lambda")
          end
        end

        context 'on Linux' do
          let(:platform) { 'linux' }

          it 'provides an install hint' do
            expect(subject.install_hint).to include("http://example.com/linux/lambda")
          end
        end
      end
    end
  end
end
