module XAttr
  module Platforms
    module Darwin
      lib LibXAttr
        {% if flag?(:darwin) %}
          fun getxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT, position : LibC::UInt32T, options : LibC::Int) : LibC::Int
          fun setxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT, position : LibC::UInt32T, options : LibC::Int) : LibC::Int
          fun listxattr(path : LibC::Char*, list : LibC::Char*, size : LibC::SizeT, options : LibC::Int) : LibC::Int
          fun removexattr(path : LibC::Char*, name : LibC::Char*, options : LibC::Int) : LibC::Int
        {% end %}
      end

      XATTR_NOFOLLOW = 0x0001
      XATTR_CREATE   = 0x0002 # set the value, fail if attr already exists
      XATTR_REPLACE  = 0x0004 # set the value, fail if attr does not exist

      def self.get(path, key, value, size, no_follow)
        options = no_follow ? XATTR_NOFOLLOW : 0

        LibXAttr.getxattr(path, key, value, size, 0, options)
      end

      def self.set(path, key, value, size, no_follow, only_create, only_replace)
        options = no_follow ? XATTR_NOFOLLOW : 0

        # If both XATTR_CREATE and XATTR_REPLACE are set
        # then it raises EINVAL
        options |= XATTR_CREATE if only_create
        options |= XATTR_REPLACE if only_replace

        LibXAttr.setxattr(path, key, value, value.bytesize, 0, options)
      end

      def self.list(path, list, size, no_follow)
        options = no_follow ? XATTR_NOFOLLOW : 0

        LibXAttr.listxattr(path, list, size, options)
      end

      def self.remove(path, key, no_follow)
        options = no_follow ? XATTR_NOFOLLOW : 0

        LibXAttr.removexattr(path, key, options)
      end
    end
  end
end
