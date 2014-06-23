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
        allow(self).to receive(:prefix_root_from_node_in_run_context) { "/opt/default" }

        with_resource_properties(:extension => "jar", :name => "gustav-moomoo")
        set_put_paths

        expect(new_resource.release_file).to eq("/var/chef/cache/gustav-moomoo.jar")
      end
    end

    context "when the resource path has been set" do
      it "sets the resource's release_file and path" do
        with_resource_properties(
          :extension => "jar",
          :name => "gustav-tootoo",
          :path => "/path/piece")
        set_put_paths

        expect(new_resource.release_file).to eq("/var/chef/cache/gustav-tootoo.jar")
        expect(new_resource.path).to eq("/path/piece/gustav-tootoo")
      end
    end

  end

  describe "#default_prefix_bin" do
    context 'when the resource prefix_bin has been set' do
      it "uses the resources prefix_bin" do
        with_resource_properties(:prefix_bin => "/resource/prefix/bin")
        expect(default_prefix_bin).to eq("/resource/prefix/bin")
      end
    end

    context 'when the resource prefix_bin has not been set' do
      it "defaults to the one on the current node" do
        allow(self).to receive(:prefix_bin_from_node_in_run_context) { "/node/prefix/bin" }
        expect(default_prefix_bin).to eq("/node/prefix/bin")
      end
    end
  end

  describe "#default_prefix_root" do
    context 'when the resource prefix_root has been set' do
      it "uses the resources prefix_root" do
        with_resource_properties(:prefix_root => "/resource/prefix/root")
        expect(default_prefix_root).to eq("/resource/prefix/root")
      end
    end

    context 'when the resource prefix_root has not been set' do
      it "defaults to the one on the current node" do
        allow(self).to receive(:prefix_root_from_node_in_run_context) { "/node/prefix/root" }
        expect(default_prefix_root).to eq("/node/prefix/root")
      end
    end
  end

  describe "#default_home_dir" do
    context 'when the resource prefix_home has been set' do
      it "uses the resources prefix_home" do
        with_resource_properties(
          :prefix_home => "/resource/prefix/home",
          :name => "resource_name")
        expect(default_home_dir).to eq("/resource/prefix/home/resource_name")
      end
    end

    context 'when the resource prefix_home has not been set' do
      it "defaults to the one on the current node" do
        with_resource_properties(:name => "resource_name")
        allow(self).to receive(:prefix_home_from_node_in_run_context) { "/node/prefix/home" }
        expect(default_home_dir).to eq("/node/prefix/home/resource_name")
      end
    end
  end

  describe "#default_path" do
    context "when the node's platform_family is windows" do
      it "returns win_install_dir" do
        with_resource_properties(:win_install_dir => "/resource/windows/install/dir")

        with_node_attributes(:platform_family => "windows")
        expect(default_path).to eq("/resource/windows/install/dir")
      end
    end

    context "when the node's platform_family is not windows" do
      it "generates a path from the prefix_root" do
        with_resource_properties(
          :prefix_root => "/resource/prefix/root",
          :name => "resource_name",
          :version => "55")

        expect(default_path).to eq("/resource/prefix/root/resource_name-55")
      end
    end
  end

  describe "#default_version" do
    context "when the resource's version has been set" do
      it "uses the version specified on the resource" do
        with_resource_properties(:version => "00001")

        expect(default_version).to eq("00001")
      end
    end

    context "when the resource's version has not been set" do
      it "defaults to 1" do
        expect(default_version).to eq("1")
      end
    end

  end

  describe "#set_paths" do

    it "uses all the defaults" do
      with_resource_properties(:extension => "jar", :name => "resource_name")

      expect(self).to receive(:default_prefix_bin) { "/default/prefix/bin" }
      expect(self).to receive(:default_prefix_root) { "/default/prefix/root" }
      expect(self).to receive(:default_home_dir) { "/default/prefix/home" }
      expect(self).to receive(:default_version) { "99" }
      expect(self).to receive(:default_path) { "/default/path" }

      set_paths

      expect(new_resource.release_file).to eq("/var/chef/cache/resource_name-99.jar")
    end

    it "sets the resource's release_file" do
      with_resource_properties(
        :extension => "jar",
        :prefix_root => "/resource/prefix/root",
        :prefix_bin => "/resource/prefix/bin",
        :prefix_home => "/resource/prefix/home",
        :version => "23",
        :name => "resource_name")

      set_paths

      chef_config_file_cache_path = "/var/chef/cache"

      expect(new_resource.release_file).to eq("#{chef_config_file_cache_path}/resource_name-23.jar")
    end

  end

  describe "#cherry_pick_tar_command" do
    it "generates the correct command" do
      with_node_attributes(:ark => { :tar => "/bin/tar" })
      with_resource_properties(
        :release_file => "/resource/release_file",
        :path => "/resource/path",
        :creates => "/resource/creates",
        :strip_components => 1)

      expected_command = "/bin/tar TAROPTIONS /resource/release_file -C /resource/path /resource/creates --strip-components=1"
      expect(cherry_pick_tar_command("TAROPTIONS")).to eq(expected_command)
    end
  end

  describe "#cherry_pick_command" do
    context "when the node's platform_family is windows" do
      it "generates a 7-zip command" do
        with_node_attributes(:platform_family => "windows")
        with_resource_properties(
          :path => "/resource/path",
          :creates => "/resource/creates")
        allow(self).to receive(:sevenzip_command_builder) { "sevenzip_command" }

        expect(cherry_pick_command).to eq("sevenzip_command -r /resource/creates")
      end
    end

    context "when the node's platform_family is not windows" do
      context 'when the unpack_type is tar_xzf' do
        it "generates a cherry pick tar command with the correct options" do
          allow(self).to receive(:unpack_type) { "tar_xzf" }
          allow(self).to receive(:cherry_pick_tar_command) { "cherry_pick_tar_command" }

          expect(cherry_pick_command).to eq("cherry_pick_tar_command")
        end
      end

      context 'when the unpack_type is tar_xjf' do
        it "generates a cherry pick tar command with the correct options" do
          allow(self).to receive(:unpack_type) { "tar_xjf" }
          allow(self).to receive(:cherry_pick_tar_command) { "cherry_pick_tar_command" }

          expect(cherry_pick_command).to eq("cherry_pick_tar_command")
        end
      end

      context 'when the unpack_type is tar_xJf' do
        it "generates a cherry pick tar command with the correct options" do
          allow(self).to receive(:unpack_type) { "tar_xJf" }
          allow(self).to receive(:cherry_pick_tar_command) { "cherry_pick_tar_command" }

          expect(cherry_pick_command).to eq("cherry_pick_tar_command")
        end
      end

      context 'when the unpack_type is unzip' do
        it "generates an unzip command" do
          allow(self).to receive(:unpack_type) { "unzip" }
          allow(self).to receive(:cherry_pick_unzip_command) { "cherry_pick_unzip_command" }

          expect(cherry_pick_command).to eq("cherry_pick_unzip_command")
        end
      end
    end
  end

  describe "#dump_command" do
    context "when the node's platform_family is windows" do
      it "generates a 7-zip command" do

      end
    end

    context "when the node's platform_family is not windows" do
      context 'when the unpack_type is tar_xzf' do
        it "generates a tar command" do
          with_resource_properties(
            :release_file => "/resource/release_file",
            :path => "/resource/path")

          allow(self).to receive(:unpack_type) { "tar_xzf" }

          expect(dump_command).to eq("tar -mxf \"/resource/release_file\" -C \"/resource/path\"")
        end
      end

      context 'when the unpack_type is tar_xjf' do
        it "generates a tar command" do
          with_resource_properties(
            :release_file => "/resource/release_file",
            :path => "/resource/path")

          allow(self).to receive(:unpack_type) { "tar_xjf" }

          expect(dump_command).to eq("tar -mxf \"/resource/release_file\" -C \"/resource/path\"")
        end
      end

      context 'when the unpack_type is tar_xJf' do
        it "generates a tar command" do
          with_resource_properties(
            :release_file => "/resource/release_file",
            :path => "/resource/path")

          allow(self).to receive(:unpack_type) { "tar_xJf" }

          expect(dump_command).to eq("tar -mxf \"/resource/release_file\" -C \"/resource/path\"")
        end
      end

      context 'when the unpack_type is unzip' do
        it "generates an unzip command" do
          with_resource_properties(
            :release_file => "/resource/release_file",
            :path => "/resource/path")

          allow(self).to receive(:unpack_type) { "unzip" }

          expect(dump_command).to eq("unzip  -j -q -u -o \"/resource/release_file\" -d \"/resource/path\"")
        end
      end
    end
  end

  describe "#sevenzip_command_builder" do
    context 'when the file extenion is a tar file' do
      it "generates the correct command" do
        with_node_attributes(:ark => { :tar => "/bin/tar" })
        with_resource_properties(
          :release_file => "/resource/release_file",
          :extension => "tar.gz")

        expected_command = "/bin/tar /param/command \"/resource/release_file\"  -so | /bin/tar x -aoa -si -ttar -o\"/param/dir\" -uy"
        expect(sevenzip_command_builder("/param/dir", "/param/command")).to eq(expected_command)
      end
    end

    context 'when the file extension is not a tar file' do
      it "generates the correct command" do
        with_node_attributes(:ark => { :tar => "/bin/tar" })
        with_resource_properties(
          :release_file => "/resource/release_file",
          :extension => "jar")

        expected_command = "/bin/tar /param/command \"/resource/release_file\"  -o\"/param/dir\" -uy"
        expect(sevenzip_command_builder("/param/dir", "/param/command")).to eq(expected_command)
      end
    end
  end

  describe "#sevenzip_command" do
    context "when the resources strip_components is greater than 0" do
      it "generates a for loop for each component being stripped" do
        with_resource_properties(
          :strip_components => 1,
          :home_dir => "/resource/home")

        allow(Dir).to receive(:mktmpdir) { "/tmp/dir" }
        allow(self).to receive(:sevenzip_command_builder) { "sevenzip_command_from_builder" }

        expected_command = "sevenzip_command_from_builder && for /f %1 in ('dir /ad /b \"\\tmp\\dir\"') do xcopy \"\\tmp\\dir\\%1\" \"/resource/home\" /s /e"
        expect(sevenzip_command).to eq(expected_command)
      end
    end

    context "when the resource's strip_components is 0" do
      it "generates a 7-zip command from the builder" do
        with_resource_properties(:strip_components => 0)

        allow(self).to receive(:sevenzip_command_builder) { "sevenzip_command_with_x" }
        expect(sevenzip_command).to eq("sevenzip_command_with_x")
      end
    end
  end

  describe "#unzip_command" do
    context "when the resource's strip_components is greater than 0" do
      it "generates a zip command" do
        with_resource_properties(
          :strip_components => 2,
          :release_file => "/resource/release_file",
          :path => "/resource/path")

        allow(Dir).to receive(:mktmpdir) { "/tmp/dir" }
        expected_command = "unzip -q -u -o /resource/release_file -d /tmp/dir && rsync -a /tmp/dir/*/*/ /resource/path && rm -rf /tmp/dir"

        expect(unzip_command).to eq(expected_command)
      end
    end

    context "when the resource's strip_components is 0" do
      it "generates a zip command" do
        with_resource_properties(
          :strip_components => 0,
          :release_file => "/resource/release_file",
          :path => "/resource/path")

        expected_command = "unzip -q -u -o /resource/release_file -d /resource/path"
        expect(unzip_command).to eq(expected_command)
      end
    end
  end

end
