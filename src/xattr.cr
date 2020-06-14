lib C
  fun getxattr(path: UInt8*, name: UInt8*, pointer: UInt8*, size: LibC::SizeT) : LibC::Int
  fun setxattr(path: UInt8*, name: UInt8*, value: UInt8*, pointer: UInt32, size: LibC::SizeT) : LibC::Int
end

module XAttr
  VERSION = "0.1.0"

  def self.get(path, key)
    Errno.value = Errno::NONE

    size = C.getxattr(path, key, nil, 0)
    return unless size > 0

    ptr = Slice(UInt8).new(size)
    res = C.getxattr(path, key, ptr, size)

    raise_error if Errno.value != Errno::NONE

    String.new(ptr)
  end

  def self.set(path, key, value)
    Errno.value = Errno::NONE

    res = C.setxattr(path, key, value, value.bytesize, 0)

    raise_error if Errno.value != Errno::NONE

    res
  end

  def self.raise_error
    raise IO::Error.new("please check the target file: #{Errno.value}")
  end
end
