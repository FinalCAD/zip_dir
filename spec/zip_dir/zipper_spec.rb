require 'spec_helper'

describe ZipDir::Zipper do
  let(:instance) { described_class.new }
  let(:tree_dir) { "spec/fixtures/tree" }

  context "given a file name" do
    let(:instance) { described_class.new('zippy') }

    before { instance.generate(tree_dir) }

    it "generated file contains name" do
      expect(File.basename(instance.file.path)).to match /\Azippy.+\.zip\z/
    end

    context "that ends with .zip" do
      let(:instance) { described_class.new('zippy.zip') }

      it "generated file contains name, but removes .zip suffix" do
        expect(File.basename(instance.file.path)).to_not match /\Azippy\.zip.+\.zip\z/
        expect(File.basename(instance.file.path)).to match /\Azippy.+\.zip\z/
      end
    end
  end

  describe "#cleanup" do
    subject { instance.cleanup }

    context "after generating" do
      before { instance.generate(tree_dir) }

      it "cleans up file" do
        expect(instance.file).to_not eql nil
        subject
        expect(instance.file).to eql nil
      end
    end
  end

  describe "file" do
    subject { instance.file }

    it "is nil" do
      expect(subject).to eql nil
    end

    context "after generating" do
      before { instance.generate(tree_dir) }

      it "the filename is defaulted" do
        filename = File.basename(subject.path)
        expect(filename.match(/\Azipper.+\z/)).to_not eql nil
      end
    end
  end

  describe "#generate" do
    subject { instance.generate(tree_dir) }

    def unzip_and_test_images(glob_result)
      unzip_path = ZipDir::Unzipper.new(instance.file.path).unzip_path

      expect(clean_glob(unzip_path)).to match_array glob_result
      test_images(unzip_path)
    end

    it "zips the folder" do
      subject
      unzip_and_test_images ["/tree", "/tree/branch", "/tree/branch/branch_image1.png",
                             "/tree/branch/branch_image2.png", "/tree/root_image.png"]
    end
  end
end