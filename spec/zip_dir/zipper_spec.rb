require 'spec_helper'

describe ZipDir::Zipper do
  let(:instance) { described_class.new }

  describe "#generate" do
    subject { instance.generate("spec/fixtures/tree") }

    it "zips the folders" do
      subject
      unzip_path = ZipDir::Unzipper.new(instance.file.path).unzip_path

      expect(Dir.clean_entries(unzip_path).size).to eql 1
      test_tree(unzip_path)
    end

    context "with two folders" do
      let(:folder1) {  }
      let(:folder2) {  }

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

        expect(Dir.clean_entries(unzip_path).size).to eql 2
        test_single(unzip_path)
        test_tree(unzip_path)
      end
    end

    def test_single(unzip_path)
      expect(Dir.clean_entries(File.join(unzip_path, "single"))).to eql %w[single_image.png]
    end

    def test_tree(unzip_path)
      expect(Dir.clean_entries(File.join(unzip_path, "tree"))).to eql %w[branch root_image.png]
      expect(Dir.clean_entries(File.join(unzip_path, "tree", "branch"))).to eql %w[branch_image1.png branch_image2.png]
    end
  end
end