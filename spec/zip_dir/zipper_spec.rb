require 'spec_helper'

describe ZipDir::Zipper do
  let(:instance) { described_class.new }
  let(:tree_dir) { "spec/fixtures/tree" }

  describe "#generated?" do
    subject { instance.generated? }

    it "is false" do
      expect(subject).to eql false
    end

    context "after generating" do
      before { instance.generate(tree_dir) }

      it "should be true" do
        expect(subject).to eql true
      end
    end
  end

  describe "file" do
    # contents are tested in #generate
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

  describe "#cleanup" do
    subject { instance.cleanup }

    it "executes anyway" do
      subject
    end

    context "after generating" do
      before { instance.generate(tree_dir) }

      it "cleans up file and copy path" do
        expect(instance.file).to_not eql nil
        expect(instance.copy_path).to_not eql nil
        copy_path = instance.copy_path

        subject

        expect(instance.file).to eql nil
        expect(instance.copy_path).to eql nil
        expect(File.directory?(copy_path)).to eql false
      end
    end
  end

  describe "#generate" do
    subject { instance.generate(tree_dir) }

    it "zips the folders" do
      subject
      unzip_path = ZipDir::Unzipper.new(instance.file.path).unzip_path

      expect(clean_glob(unzip_path)).to match_array ["/tree", "/tree/branch", "/tree/branch/branch_image1.png",
                                                     "/tree/branch/branch_image2.png", "/tree/root_image.png"]
      test_images(unzip_path)
    end

    context "with two folders" do
      subject do
        instance.generate do |instance|
          ["single", "tree"].each do |folder|
            instance.add_path "spec/fixtures/#{folder}"
          end
        end
      end

      it "zips the folders" do
        subject
        unzip_path = ZipDir::Unzipper.new(instance.file.path).unzip_path
        expect(clean_glob(unzip_path)).to match_array ["/single", "/single/single_image.png", "/tree", "/tree/branch",
                                                       "/tree/branch/branch_image1.png", "/tree/branch/branch_image2.png",
                                                       "/tree/root_image.png"]
        test_images(unzip_path)
      end
    end
  end
end