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

      path = instance.unzip_path
      expect_entries(path).to eql %w[tree]

      path = File.join(path, "tree")
      expect_entries(path).to eql %w[branch root_image.png]

      expect(File.read(File.join(path, "root_image.png"))).to eql File.read("spec/fixtures/tree/root_image.png")


      path = File.join(path, "branch")
      images = %w[branch_image1.png branch_image2.png]
      expect_entries(path).to eql images
      images.each do |image|
        expect(File.read(File.join(path, image))).to eql File.read("spec/fixtures/tree/branch/#{image}")
      end
    end
  end
end