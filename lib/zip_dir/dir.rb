module ZipDir
  class Dir
    attr_reader :copy_path

    def generated?
      !!@generated
    end

    def generate(source_path=nil, options={})
      cleanup if generated?

      @copy_path = ::Dir.mktmpdir
      proxy = Proxy.new(copy_path)
      if source_path
        raise "Should not give block and source_path" if block_given?
        proxy.add_path source_path, options
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

      def add_path(source_path, options={})
        options = options.inject({}){|hash,(k,v)| hash[k.to_sym] = v; hash}

        if File.directory?(source_path)
          add_directory source_path, options
        elsif File.file?(source_path)
          add_file source_path, options
        else
          raise "Attempting to add non-existent path."
        end
      end
      alias_method :<<, :add_path

      protected
      def add_directory(source_path, options)
        if options[:flatten_directories]
          glob = "#{source_path}/**/*"
          options[:extension] = '*' unless options[:extension]
        elsif options[:root_directory]
          glob = "#{source_path}/*"
        end

        if glob
          glob += ".{#{Array[options[:extension]].join(",")}}" if options[:extension]
          return ::Dir.glob(glob).each { |path| add_path(path) }
        end

        FileUtils.cp_r source_path, @copy_path
      end

      def add_file(source_path, options)
        copy_path_parts = [@copy_path]

        if options[:rename]
          rename = options[:rename]
          rename += File.extname(source_path) if File.extname(rename).empty?
          copy_path_parts << rename
        end

        FileUtils.cp_r source_path, copy_path_parts.join("/")
      end
    end
  end
end