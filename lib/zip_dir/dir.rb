module ZipDir
  class Dir
    attr_reader :copy_path

    def generated?
      !!@generated
    end

    def generate(source_path=nil, root_directory: false)
      cleanup if generated?

      @copy_path = ::Dir.mktmpdir
      proxy = Proxy.new(copy_path)
      if source_path
        raise "should not give block and source_path" if block_given?
        proxy.add_path source_path, root_directory: root_directory
      else
        yield proxy
      end

      ::Dir.new(copy_path)
    ensure
      @generated = true
    end

    def cleanup
      FileUtils.remove_entry_secure copy_path if copy_path
      @copy_path = nil
      @generated = false
    end

    class Proxy
      def initialize(copy_path)
        @copy_path = copy_path
      end

      def add_path(source_path, root_directory: false)
        return ::Dir.glob("#{source_path}/*").each { |path| add_path(path) } if File.directory?(source_path) && root_directory
        FileUtils.cp_r source_path, [@copy_path].join("/")
      end
      alias_method :<<, :add_path
    end
  end
end