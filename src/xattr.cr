require "./xattr/**"

# Crystal bindings to XATTR.
# This library allows to manage extended file attributes (XATTR) as file metadata.
module XAttr
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  def self.new(path : String | Path, no_follow = false, only_create = false, only_replace = false)
    XAttr.new(path, no_follow: no_follow, only_create: only_create, only_replace: only_replace)
  end
end
