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

      def self.get(path, key, value, size, no_follow)
        if no_follow
          LibXAttr.lgetxattr(path, key, value, size)
        else
          LibXAttr.getxattr(path, key, value, size)
        end
      end

      def self.set(path, key, value, size, no_follow)
        if no_follow
          LibXAttr.lsetxattr(path, key, value, value.bytesize, 0)
        else
          LibXAttr.setxattr(path, key, value, value.bytesize, 0)
        end
      end

      def self.list(path, list, size)
        LibXAttr.listxattr(path, list, size)
      end

      def self.remove(path, key)
        LibXAttr.removexattr(path, key)
      end
    end
  end
end
