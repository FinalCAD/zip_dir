module ZipDir
  class Unzipper
    attr_reader :zip_path
    def initialize(zip_path)
      @zip_path, @unzip_path = zip_path, Dir.mktmpdir
    end

    def cleanup
      @unzipped = false
      FileUtils.remove_entry_secure @unzip_path
    end

    def unzip_path
      unzip unless unzipped?
      @unzip_path
    end

    def unzipped?
      !!@unzipped
    end

    def unzip
      ::Zip::File.open(zip_path) do |zip_file|
        zip_file.each do |entry|
          file_path = "#{@unzip_path}/#{entry.name}"

          # Fixes:
          # Errno::ENOENT:
          # No such file or directory @ rb_sysopen - /var/folders/6c/s4snqy051jqdpbjw7f7tsn940000gn/T/d20160209-56123-1o14n5n/Niveaux/Fondations.png
          dir_path = File.dirname(file_path).to_s
          FileUtils.mkdir_p dir_path unless File.exists?(dir_path)

          entry.extract(file_path) unless File.exists?(file_path)
        end
      end
      @unzipped = true
    end
  end
end
