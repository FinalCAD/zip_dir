require 'spec_helper'

describe ZipDir::Zip do
  let(:source_path) { "spec/fixtures/single" }
  let(:instance) { described_class.new(source_path) }

  describe "#generated?" do
    subject { instance.generated? }

    it "is false" do
      expect(subject).to eql false
    end

    context "after generating" do
      before { instance.generate }

      it "should be true" do
        expect(subject).to eql true
      end
    end
  end

  describe "file" do
    # contents are tested in #generate
    subject { instance.file }

    it "the filename is defaulted" do
      filename = File.basename(subject.path)
      expect(filename.match(/\Azip.+\z/)).to_not eql nil
    end
  end

  describe "generate" do
    subject { instance.generate }

    it "generates the zip" do
      subject
      unzip_path = ZipDir::Unzipper.new(instance.file.path).unzip_path

      expect(Dir.clean_entries(unzip_path)).to eql %w[single_image.png]
      file_path = File.join(unzip_path, "single_image.png")
      expect(File.read(file_path)).to eql File.read(File.join(source_path, "single_image.png"))
    end
  end
end