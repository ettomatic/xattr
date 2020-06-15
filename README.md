# XAttr

Crystal bindings to [XATTR](https://man7.org/linux/man-pages/man7/xattr.7.html).

This library allow to manage extended file attributes (XATTR) as file metadata.


## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     xattr:
       github: ettomatic/xattr
   ```

2. Run `shards install`

## Usage

```crystal
require "xattr"

 xattr = XAttr.new("./myfile.txt")
 xattr["tags"] = "mytag1,mytag2"
 xattr["tags"]
 # => "mytag1,mytag2"

 xattr.list
 # => ["tags"]

 xattr.remove("tags")
 xattr.list
 # => []

 xattr["tags"]
 # => nil
```

## Contributing

1. Fork it (<https://github.com/ettomatic/xattr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Ettore Berardi](https://github.com/ettomatic) - creator and maintainer
