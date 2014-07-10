require 'spec_helper'
require './libraries/default'

describe Ark::TarCommandBuilder do

  let(:subject) { described_class.new(resource) }

  let(:resource) do
    double(release_file: "release_file",
           creates: "creates",
           path: "path",
           strip_components: 1,
           extension: "tar.gz")
  end

  before(:each) do
    allow(subject).to receive(:tar_binary) { "/bin/tar" }
  end

  describe "#unpack" do
    it "generates the correct command" do
      expected_command = "/bin/tar xzf release_file --strip-components=1"
      expect(subject.unpack).to eq(expected_command)
    end

    context "when the extension is tar" do

      let(:resource) do
        double(release_file: "release_file",
               creates: "creates",
               path: "path",
               strip_components: 1,
               extension: "tar")
      end

      it "generates the correct command" do
        expected_command = "/bin/tar xzf release_file --strip-components=1"
        expect(subject.unpack).to eq(expected_command)
      end
    end

  end

  describe "#dump" do
    it "generates the correct command" do
      expected_command = "tar -mxf \"release_file\" -C \"path\""
      expect(subject.dump).to eq(expected_command)
    end
  end

  describe "#cherry_pick" do
    it "generates the correct command" do
      expected_command = "/bin/tar xzf release_file -C path creates --strip-components=1"
      expect(subject.cherry_pick).to eq(expected_command)
    end
  end
end
