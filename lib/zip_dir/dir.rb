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
        raise "should not give block and source_path" if block_given?
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
        return ::Dir.glob("#{source_path}/*").each { |path| add_path(path) } if File.directory?(source_path) && options[:root_directory]

        copy_path_parts = [@copy_path]

        if File.file?(source_path) && options[:rename]
          rename = options[:rename]
          rename += File.extname(source_path) if File.extname(rename).empty?
          copy_path_parts << rename
        end

        FileUtils.cp_r source_path, copy_path_parts.join("/")
      end
      alias_method :<<, :add_path
    end
  end
end