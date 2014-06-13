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

end