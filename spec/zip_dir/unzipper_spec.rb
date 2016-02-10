require 'spec_helper'

describe ZipDir::Unzipper do
  let(:instance) { described_class.new(zip_path) }

  describe "#unzip" do
    subject { instance.unzip }

    shared_examples "unzip tests" do
      it "unzips the result" do
        subject

        unzip_path = instance.unzip_path
        expect(clean_glob(unzip_path)).to match_array result
        test_images(unzip_path)
      end
    end

    context "tree" do
      let(:zip_path) { "spec/fixtures/tree.zip" }
      let(:result) {
        ["/tree", "/tree/branch", "/tree/branch/branch_image1.png",
         "/tree/branch/branch_image2.png", "/tree/root_image.png"]
      }

      include_examples "unzip tests"
    end

    context "encoded differently" do
      let(:zip_path) { "spec/fixtures/encoded_differently.zip" }
      let(:result) {
        ["/Niveaux", "/Niveaux/Sector&éùô.png",
         "/Zones", "/Zones/Sector&éùô",
         "/Zones/Sector&éùô/Plancher 1 &éùô.png",
         "/Zones/Sector&éùô/Plancher 2 &éùô-==-Ferraillage&éùô.png",
         "/Zones/Sector&éùô/Plancher 2 &éùô-==-Nappe inferieur&éùô.png",
         "/Zones/Sector&éùô/Plancher 2 &éùô-==-Nappe superieure&éùô.png"]
      }

      include_examples "unzip tests"
    end
  end
end