# Crystal bindings to XATTR.
# This library allows to manage extended file attributes (XATTR) as file metadata.
class XAttr
  VERSION = "0.4.0"

  lib LibXAttr
    {% if flag?(:linux) %}
      fun getxattr(path : LibC::Char*, name : LibC::Char*, pointer : LibC::Char*, size : LibC::SizeT) : LibC::Int
      fun setxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, pointer : UInt32, size : LibC::SizeT) : LibC::Int
      fun listxattr(path : LibC::Char*, pointer : LibC::Char*, size : LibC::SizeT) : LibC::Int
      fun removexattr(path : LibC::Char*, name : LibC::Char*) : LibC::Int
    {% elsif flag?(:darwin) %}
      # TODO: WIP
      {% raise "No XAttr::LibXAttr implementation available for this platform" %}
    {% else %}
      {% raise "No XAttr::LibXAttr implementation available for this platform" %}
    {% end %}
  end

  def initialize(path : String)
    @path = path
  end

  def [](key)
    size = LibXAttr.getxattr(@path, key, nil, 0)
    return unless size > 0

    ptr = Slice(LibC::Char).new(size)
    res = LibXAttr.getxattr(@path, key, ptr, size)
    raise_error(res) if res == -1

    String.new(ptr)
  end

  def []=(key, value)
    res = LibXAttr.setxattr(@path, key, value, value.bytesize, 0)
    raise_error(res) if res == -1

    res
  end

  def list
    size = LibXAttr.listxattr(@path, nil, 0)
    return [] of String unless size > 0

    ptr = Slice(LibC::Char).new(size)
    LibXAttr.listxattr(@path, ptr, size)

    String.new(ptr).split("\000", remove_empty: true)
  end

  def remove(key)
    res = LibXAttr.removexattr(@path, key)
    raise_error(res) if res == -1

    res
  end

  private def raise_error(res)
    raise IO::Error.from_errno("Please check the target file")
  end
end
