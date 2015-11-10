require "zip_dir/zip"

module ZipDir
  class Zipper
    attr_reader :copy_path, :filename

    DEFAULT_FILENAME = "zipper.zip".freeze

    def initialize(filename=DEFAULT_FILENAME)
      @filename = filename
    end

    def generated?
      !!@generated
    end

    def generate(source_path=nil)
      cleanup if generated?

      @copy_path = Dir.mktmpdir
      proxy = Proxy.new(copy_path)
      if source_path
        raise "should not give block and source_path" if block_given?
        proxy.add_path source_path
      else
        yield proxy
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
      FileUtils.remove_entry_secure copy_path if copy_path
      @file = @copy_path = nil
      @generated = false
    end

    class Proxy
      def initialize(copy_path)
        @copy_path = copy_path
      end

      def add_path(source_path)
        FileUtils.cp_r source_path, @copy_path
      end
      alias_method :<<, :add_path
    end
  end
end