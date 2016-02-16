module ZipDir
  class Unzipper
    attr_reader :zip_path
    def initialize(zip_path)
      @zip_path, @unzip_path = zip_path, ::Dir.mktmpdir
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
          next if unauthorized_file?(entry)

          file_path = "#{@unzip_path}/#{entry.name}"

          # Fixes: spec/fixtures/encoded_differently.zip (in a test)
          ensure_path_exists file_path

          entry.extract(file_path) unless File.exists?(file_path)
        end
      end
      @unzipped = true
    end

    private

    def unauthorized_file?(file)
      file.name.match(/MACOSX|.DS_Store/)
    end

    def ensure_path_exists file_path
      # Create directory structure if doesn't exists
      if file_path.to_s.match(/(?<last_character>\/$)/)
        FileUtils.mkdir_p file_path.to_s unless File.exists?(file_path.to_s)
      end

      # We are not sure about is a directory structure or not,
      # we look one level up and we take a look if necessary to create structure or not.
      unless File.exists?(dirpath = File.dirname(file_path.to_s))
        FileUtils.mkdir_p dirpath.to_s
      end
    end
  end
end
