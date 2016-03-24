module ZipDir
  class Zip
    attr_reader :source_path
    def initialize(source_path, filename="zip.zip")
      filename = filename.chomp(".zip")
      @source_path, @file = source_path, Tempfile.new(["#{filename}-", ".zip"])
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

    protected
    def zip_path(zip_io, relative_path="")
      entries = ::Dir.entries(relative_path.empty? ? source_path : File.join(source_path, relative_path))
      entries.delete(".")
      entries.delete("..")
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