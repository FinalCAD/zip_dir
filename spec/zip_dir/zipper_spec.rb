require 'spec_helper'

describe ZipDir::Zipper do
  let(:instance) { described_class.new }

  describe "#file" do
    subject { instance.file }

    context "after copying folders" do
      let(:folder1) { "single" }
      let(:folder2) { "tree" }

      before do
        instance.generate do |instance|
          [folder1, folder2].each do |folder|
            instance.add_path "spec/fixtures/#{folder}"
          end
        end
      end

      it "zips the folders" do
        unzip_path = ZipDir::Unzipper.new(subject.path).unzip_path
        entries = Dir.clean_entries unzip_path

        expect(entries.size).to eql 2
        expect(Dir.clean_entries(File.join(unzip_path, folder1))).to eql %w[single_image.png]

        expect(Dir.clean_entries(File.join(unzip_path, folder2))).to eql %w[branch root_image.png]
        expect(Dir.clean_entries(File.join(unzip_path, folder2, "branch"))).to eql %w[branch_image1.png branch_image2.png]
      end
    end
  end
end