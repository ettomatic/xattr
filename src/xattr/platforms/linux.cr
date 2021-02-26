module XAttr
  module Platforms
    module Linux
      lib LibXAttr
        {% if flag?(:linux) %}
          fun getxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT) : LibC::Int
          fun setxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT, options : LibC::Int) : LibC::Int
          fun listxattr(path : LibC::Char*, list : LibC::Char*, size : LibC::SizeT) : LibC::Int
          fun removexattr(path : LibC::Char*, name : LibC::Char*) : LibC::Int
          fun lgetxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT) : LibC::Int
          fun lsetxattr(path : LibC::Char*, name : LibC::Char*, value : LibC::Char*, size : LibC::SizeT, options : LibC::Int) : LibC::Int
          fun llistxattr(path : LibC::Char*, list : LibC::Char*, size : LibC::SizeT) : LibC::Int
          fun lremovexattr(path : LibC::Char*, name : LibC::Char*) : LibC::Int
        {% end %}
      end

      XATTR_CREATE  = 0x1 # set value, fail if attr already exists
      XATTR_REPLACE = 0x2 # set value, fail if attr does not exist

      def self.get(path, key, value, size, no_follow)
        if no_follow
          LibXAttr.lgetxattr(path, key, value, size)
        else
          LibXAttr.getxattr(path, key, value, size)
        end
      end

      def self.set(path, key, value, size, no_follow, only_create, only_replace)
        options = 0
        # If both XATTR_CREATE and XATTR_REPLACE are set
        # then it raises ENODATA if attribute not exists
        # and EEXIST if attribute already exists.
        options |= XATTR_CREATE if only_create
        options |= XATTR_REPLACE if only_replace

        if no_follow
          LibXAttr.lsetxattr(path, key, value, value.bytesize, options)
        else
          LibXAttr.setxattr(path, key, value, value.bytesize, options)
        end
      end

      def self.list(path, list, size, no_follow)
        if no_follow
          LibXAttr.llistxattr(path, list, size)
        else
          LibXAttr.listxattr(path, list, size)
        end
      end

      def self.remove(path, key, no_follow)
        if no_follow
          LibXAttr.lremovexattr(path, key)
        else
          LibXAttr.removexattr(path, key)
        end
      end
    end
  end
end
