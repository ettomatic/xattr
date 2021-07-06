module XAttr
  class XAttr
    def initialize(@path : String | Path, @no_follow = false, @only_create = false, @only_replace = false)
			@path = Path.new(@path).expand
			raise File::NotFoundError.from_errno("Please check the target file: No such file or directory", file: @path) unless File.exists? @path
    end

    def [](key)
      size = bindings.get(@path.to_s, key, nil, 0, @no_follow)
      raise_error(size) if size == -1
      return unless size > 0

      ptr = Slice(LibC::Char).new(size)
      res = bindings.get(@path.to_s, key, ptr, size, @no_follow)
      raise_error(res) if res == -1

      String.new(ptr)
    end

    def []=(key, value)
      res = bindings.set(@path.to_s, key, value, value.bytesize, @no_follow, @only_create, @only_replace)
      raise_error(res) if res == -1

      res
    end

    def keys
      size = bindings.list(@path.to_s, nil, 0, @no_follow)
      raise_error(size) if size == -1
      return [] of String unless size > 0

      ptr = Slice(LibC::Char).new(size)
      bindings.list(@path.to_s, ptr, size, @no_follow)

      String.new(ptr).split("\000", remove_empty: true).sort
    end

    def remove(key)
      res = bindings.remove(@path.to_s, key, @no_follow)
      raise_error(res) if res == -1
      res
    end

    def each
      keys.each do |k|
        yield k, self.[](k)
      end
    end

    def to_h
      hash = {} of String => String | Nil
      each { |k, v| hash[k] = v }
      hash
    end

    private def raise_error(res)
      raise File::Error.from_errno("Please check the target file", file: @path)
    end

    private def bindings
      {% if flag?(:linux) %}
        Platforms::Linux
      {% elsif flag?(:darwin) %}
        Platforms::Darwin
      {% else %}
        {% raise "XAttr Not implemented for this platform" %}
      {% end %}
    end
  end
end
