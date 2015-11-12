require 'spec_helper'

describe ZipDir::Unzipper do
  let(:zip_path) { "spec/fixtures/tree.zip" }
  let(:instance) { described_class.new(zip_path) }

  describe "unzip" do
    subject { instance.unzip }

    def expect_entries(path)
      expect(Dir.clean_entries(path))
    end

    it "works" do
      subject

      unzip_path = instance.unzip_path
      expect(clean_glob(unzip_path)).to match_array ["/tree", "/tree/branch", "/tree/branch/branch_image1.png",
                                                     "/tree/branch/branch_image2.png", "/tree/root_image.png"]
      test_images(unzip_path)
    end
  end
end