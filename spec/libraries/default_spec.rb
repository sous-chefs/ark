require "spec_helper"

require './libraries/default'

describe_helpers Opscode::Ark::ProviderHelpers do

  describe "#parse_file_extension" do

    it "returns the extension parameter specified on the resource" do
      with_resource_properties(:extension => "me")
      expect(parse_file_extension).to eq "me"
    end

    context "when the extension is nil" do

      it "creates an extension based on the file specified in the URL" do
        with_resource_properties(:extension => nil, :url => "http://localhost/file.tgz")
        expect(parse_file_extension).to eq "tgz"
      end

      it "creates an extension based on the file specified in the URL (and not other words with similar names to extensions)" do
        with_resource_properties(:extension => nil, :url => "https://jar.binfiles.tbz/file.tar.bz2")
        expect(parse_file_extension).to eq "tar.bz2"
      end

      context "when the archive format is not supported" do

        it "it returns a nil extension" do
          with_resource_properties(:extension => nil, :url => "http://localhost/file.stuffit")
          expect(parse_file_extension).to eq nil
        end

      end

      context "when the url contains a query string" do

        it "creates an extension based on the file specified in the URL" do
          with_resource_properties(:extension => nil, :url => "http://localhost/file.version.txz-bin?latest=true")
          expect(parse_file_extension).to eq "txz"
        end

      end

    end

  end

  describe "#unpack_type" do
    context 'when given a tar.gz' do
      it "returns the correct command with parameters" do
        with_resource_properties(:extension => "tar.gz")
        expect(unpack_type).to eq("tar_xzf")
      end

      it "returns the correct command with parameters" do
        with_resource_properties(:extension => "tgz")
        expect(unpack_type).to eq("tar_xzf")
      end
    end

    context 'when given a tar.bz2' do
      it "returns the correct command with parameters" do
        with_resource_properties(:extension => "tar.bz2")
        expect(unpack_type).to eq("tar_xjf")
      end

      it "returns the correct command with parameters" do
        with_resource_properties(:extension => "tbz")
        expect(unpack_type).to eq("tar_xjf")
      end
    end

    context 'when given a tar.xz' do
      it "returns the correct command with parameters" do
        with_resource_properties(:extension => "tar.xz")
        expect(unpack_type).to eq("tar_xJf")
      end

      it "returns the correct command with parameters" do
        with_resource_properties(:extension => "txz")
        expect(unpack_type).to eq("tar_xJf")
      end
    end

    context 'when given a zip' do
      it "returns the correct command with parameters" do
        with_resource_properties(:extension => "zip")
        expect(unpack_type).to eq("unzip")
      end
    end

    context 'when given a war' do
      it "returns the correct command with parameters" do
        with_resource_properties(:extension => "war")
        expect(unpack_type).to eq("unzip")
      end
    end

    context 'when given a jar' do
      it "returns the correct command with parameters" do
        with_resource_properties(:extension => "jar")
        expect(unpack_type).to eq("unzip")
      end
    end
  end

  describe "#tar_command" do

    it "generates the correct tar command with the flags and release file" do
      with_node_attributes(:ark => { :tar => "/bin/tar" })
      with_resource_properties(:release_file => "myfile.txz", :strip_components => 0)

      expect(tar_command("xJf")).to eq("/bin/tar xJf myfile.txz")
    end

  end

  describe "#tar_strip_args" do
    context "when the strip components count is 0" do
      it "returns no strip component command" do
        with_resource_properties(:strip_components => 0)

        expect(tar_strip_args).to eq("")
      end
    end

    context "when the strip components count is greater than 0" do
      it "returns a strip component command" do
        with_resource_properties(:strip_components => 2)

        expect(tar_strip_args).to eq(" --strip-components=2")
      end
    end
  end

  describe "#owner_command" do
    context "when on windows" do
      it "generates a icacls command" do
        with_node_attributes(:platform_family => "windows")
        with_resource_properties(:owner => "Bobo", :path => "C:\\temp")

        expect(owner_command).to eq("icacls C:\\temp\\* /setowner Bobo")
      end
    end

    context "when not on windows" do
      it "generates a chown command" do
        with_resource_properties(:owner => "MouseTrap", :group => "RatCatchers", :path => "/opt/rathole")

        expect(owner_command).to eq("chown -R MouseTrap:RatCatchers /opt/rathole")
      end
    end
  end

  describe "#show_deprecations" do
    context "when setting the strip_leading_dir property on the resource" do
      it "warns that it is deprecated when set to true" do
        with_resource_properties(:strip_leading_dir => true)
        expect(Chef::Log).to receive(:warn)
        show_deprecations
      end

      it "warns that it is deprecated when set to false" do
        with_resource_properties(:strip_leading_dir => false)
        expect(Chef::Log).to receive(:warn)
        show_deprecations
      end

    end

    context "when the strip_leading_dir property is not set on the resource" do
      it "does not produce a warning" do
        with_resource_properties(:strip_leading_dir => nil)
        expect(Chef::Log).not_to receive(:warn)
        show_deprecations
      end
    end
  end

  describe "#set_dump_paths" do
    it "sets the resource's release_file" do
      with_resource_properties(:extension => "tar.gz", :name => "what_is_a_good_name")
      set_dump_paths
      expect(new_resource.release_file).to eq("/var/chef/cache/what_is_a_good_name.tar.gz")
    end
  end

  describe "#set_put_paths" do

    context "when the resource path is not set" do
      it "sets the resource's release_file and path" do
        # This is a workaround because I don't want to mock out the run_context
        allow(self).to receive(:prefix_root_from_node_in_run_context) { "/opt/default" }

        with_resource_properties(:extension => "jar", :name => "gustav-moomoo")
        set_put_paths

        expect(new_resource.release_file).to eq("/var/chef/cache/gustav-moomoo.jar")
      end
    end

    context "when the resource path has been set" do
      it "sets the resource's release_file and path" do
        with_resource_properties(:extension => "jar", :name => "gustav-tootoo", :path => "/path/piece")
        set_put_paths

        expect(new_resource.release_file).to eq("/var/chef/cache/gustav-tootoo.jar")
        expect(new_resource.path).to eq("/path/piece/gustav-tootoo")
      end
    end

  end

end
