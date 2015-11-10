require "zip_dir/zip"

module ZipDir
  class Zipper
    attr_reader :copy_path, :filename

    def initialize(filename="zipper.zip")
      @filename = filename
      @copy_path = Dir.mktmpdir
    end

    def add_path(source_path)
      FileUtils.cp_r source_path, copy_path
    end
    alias_method :<<, :add_path

    def generated?
      !!@generated
    end

    def generate(source_path=nil)
      cleanup if generated?

      if source_path
        raise "should not give block and source_path" if block_given?
        add_path source_path
      else
        yield self
      end

      @file = ZipDir::Zip.new(copy_path, filename).file
    ensure
      @generated = true
    end

    def file
      return unless generated?
      @file
    end

    def cleanup
      FileUtils.remove_entry_secure copy_path
      @generated = false
    end
  end
end