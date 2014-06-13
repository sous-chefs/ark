require "spec_helper"

describe_recipe "ark::default" do

  def node_properties
    { :platform => "windows", :version => "2008R2" }
  end

  let(:expected_packages) do
    %w( libtool autoconf unzip rsync make gcc autogen xz-lzma-compat )
  end

  it "does not installs packages" do
    expected_packages.each do |package|
      expect(chef_run).not_to install_package(package)
    end
  end

  context "sets default attributes" do

    it "tar binary" do
      expect(default_cookbook_attribute("tar")).to eq %("\\7-zip\\7z.exe")
    end

  end

end
