require "./xattr/**"

# Crystal bindings to XATTR.
# This library allows to manage extended file attributes (XATTR) as file metadata.
module XAttr
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  def self.new(path : String, no_follow = false)
    XAttr.new(path, no_follow: no_follow)
  end
end
