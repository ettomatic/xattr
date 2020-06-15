lib C
  fun getxattr(path : UInt8*, name : UInt8*, pointer : UInt8*, size : LibC::SizeT) : LibC::Int
  fun setxattr(path : UInt8*, name : UInt8*, value : UInt8*, pointer : UInt32, size : LibC::SizeT) : LibC::Int
  fun listxattr(path : UInt8*, pointer : UInt8*, size : LibC::SizeT) : LibC::Int
  fun removexattr(path : UInt8*, name : UInt8*) : LibC::Int
end

# Crystal bindings to XATTR.
# This library allow to manage extended file attributes (XATTR) as file metadata.
class XAttr
  VERSION = "0.4.0"

  def initialize(path : String)
    @path = path
  end

  def [](key)
    size = C.getxattr(@path, key, nil, 0)
    return unless size > 0

    ptr = Slice(UInt8).new(size)
    res = C.getxattr(@path, key, ptr, size)
    raise_error if res == -1

    String.new(ptr)
  end

  def []=(key, value)
    res = C.setxattr(@path, key, value, value.bytesize, 0)
    raise_error if res == -1

    res
  end

  def list
    size = C.listxattr(@path, nil, 0)
    return [] of String unless size > 0

    ptr = Slice(UInt8).new(size)
    C.listxattr(@path, ptr, size)

    String.new(ptr).split("\000", remove_empty: true)
  end

  def remove(key)
    res = C.removexattr(@path, key)
    raise_error if res == -1

    res
  end

  private def raise_error
    raise IO::Error.new("#{Errno.value} - please check the target file")
  end
end
