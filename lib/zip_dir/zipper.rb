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

      @file = Zip.new(copy_path, filename).file
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

    class Zip
      attr_reader :source_path
      def initialize(source_path, filename)
        @source_path, @file = source_path, Tempfile.new(filename)
      end

      def file
        generate unless generated?
        @file
      end

      def generate
        ::Zip::File.open(@file.path, ::Zip::File::CREATE) do |zip_io|
          zip_path(zip_io)
        end
        @generated = true
      end

      def generated?
        !!@generated
      end

      def zip_path(zip_io, relative_path="")
        entries = Dir.clean_entries(relative_path.empty? ? source_path : File.join(source_path, relative_path))
        entries.each do |entry|
          relative_entry_path = relative_path.empty? ? entry : File.join(relative_path, entry)
          source_entry_path = File.join(source_path, relative_entry_path)

          if File.directory?(source_entry_path)
            zip_io.mkdir relative_entry_path
            zip_path zip_io, relative_entry_path
          else
            zip_io.add relative_entry_path, source_entry_path
          end
        end
      end
    end
  end
end