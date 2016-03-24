require "zip_dir/dir"
require "zip_dir/zip"

module ZipDir
  class Zipper < Dir
    attr_reader :filename

    DEFAULT_FILENAME = "zipper.zip".freeze

    def initialize(filename=DEFAULT_FILENAME)
      @filename = filename
    end

    def generate(source_path=nil, root_directory: false)
      super
      @file = ZipDir::Zip.new(copy_path, filename).file
    end

    def cleanup
      super
      @file = nil
    end

    def file
      return unless generated?
      @file
    end
  end
end