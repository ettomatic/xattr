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

      def get(path, key, value)
        LibXAttr.getxattr(path, key, ptr, size, 0, 0)
      end

      def set(path, key, value, size)
        LibXAttr.setxattr(path, key, value, value.bytesize, 0, 0)
      end

      def list(path, list, size)
        LibXAttr.listxattr(path, ptr, size, 0)
      end

      def remove(path, key)
        LibXAttr.removexattr(path, key, 0)
      end
    end
  end
end
