require 'spec_helper'
require './libraries/default'

describe Ark::SevenZipCommandBuilder do
  let(:subject) { described_class.new(resource) }

  let(:resource) do
    double(release_file: 'release_file',
           creates: 'creates',
           path: 'path',
           home_dir: 'home_dir',
           strip_components: 1,
           extension: 'tar.gz')
  end

  before(:each) do
    allow(subject).to receive(:sevenzip_binary) { '"C:\\Program Files\\7-zip\\7z.exe"' }
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('SystemRoot').and_return('c:\\Windows')
  end

  describe '#unpack' do
    it 'generates the correct command' do
      allow(subject).to receive(:make_temp_directory) { 'temp_directory' }
      expected_command = "\"C:\\Program Files\\7-zip\\7z.exe\" x \"release_file\" -so | \"C:\\Program Files\\7-zip\\7z.exe\" x -aoa -si -ttar -o\"temp_directory\" -uy && for /f %1 in ('dir /ad /b \"temp_directory\"') do (\"c:\\Windows\\System32\\robocopy\" \"temp_directory\\%1\" \"path\" /s /e) ^& IF %ERRORLEVEL% LEQ 3 cmd /c exit 0"
      expect(subject.unpack).to eq(expected_command)
    end
  end

  describe '#dump' do
    it 'generates the correct command' do
      expected_command = '"C:\\Program Files\\7-zip\\7z.exe" e "release_file" -so | "C:\\Program Files\\7-zip\\7z.exe" x -aoa -si -ttar -o"path" -uy'
      expect(subject.dump).to eq(expected_command)
    end
  end

  describe '#cherry_pick' do
    it 'generates the correct command' do
      expected_command = '"C:\\Program Files\\7-zip\\7z.exe" x "release_file" -so | "C:\\Program Files\\7-zip\\7z.exe" x -aoa -si -ttar -o"path" -uy -r creates'
      expect(subject.cherry_pick).to eq(expected_command)
    end
  end

  context 'strip_components == 0' do
    describe '#unpack' do
      it 'generates the correct command' do
        allow(resource).to receive(:strip_components).and_return(0)
        expected_command = '"C:\\Program Files\\7-zip\\7z.exe" x "release_file" -so | "C:\\Program Files\\7-zip\\7z.exe" x -aoa -si -ttar -o"path" -uy'
        expect(subject.unpack).to eq(expected_command)
      end
    end
  end
end
