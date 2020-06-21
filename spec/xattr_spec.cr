require "./spec_helper"

describe XAttr do
  key = "user.xdg.tags"
  path = "spec/test_dir/test_get.txt"

  before_each do
    Dir["spec/test_dir/*.txt"].each { |f| File.delete(f) }
  end

  describe "get" do
    it "returns the specific xattr value assigned to a target file" do
      file = File.touch(path)

      xattr = XAttr.new(path)
      xattr[key] = "mytag1"
      xattr[key].should eq "mytag1"
    end

    it "raises IO Error if xattr is not set" do
      file = File.touch(path)

      {% if flag?(:linux) %}
        expect_raises(IO::Error, "Please check the target file: Operation not supported") do
          xattr = XAttr.new(path)
          xattr["foo"]
        end
      {% elsif flag?(:darwin) %}
        expect_raises(IO::Error, "Please check the target file: Attribute not found") do
          xattr = XAttr.new(path)
          xattr["foo"]
        end
      {% end %}
    end

    it "raises IO Error ENOENT if target file is missing" do
      expect_raises(IO::Error, "Please check the target file: No such file or directory") do
        xattr = XAttr.new("spec/not_there.txt")
        xattr[key]
      end
    end
  end

  describe "set" do
    it "sets a value to the target file" do
      file = File.touch(path)

      xattr = XAttr.new(path)
      xattr[key] = "mytag1"
      xattr[key].should eq "mytag1"
    end

    it "overrides existing value" do
      file = File.touch(path)

      xattr = XAttr.new(path)

      xattr[key] = "mytag1"
      xattr[key].should eq "mytag1"

      xattr[key] = "mytag2"
      xattr[key].should eq "mytag2"
    end

    it "raise an exception if the target file is missing" do
      expect_raises(IO::Error, "Please check the target file: No such file or directory") do
        xattr = XAttr.new("spec/test_dir/not_there.txt")
        xattr[key] = "mytag1"
      end
    end
  end

    describe "keys" do
      context "with xattrs set on the target file" do
        it "returns the attrs assigned to a target file sorted alphabetically" do
          file = File.touch(path)

          xattr = XAttr.new(path)

          xattr[key] = "mytag1"
          xattr["user.xdg.comments"] = "foobar"

          xattr.keys.should eq ["user.xdg.comments", "user.xdg.tags"]
        end
      end

      context "with no xattrs set on the file" do
        it "returns an empty array" do
          file = File.touch(path)

          xattr = XAttr.new(path)
          xattr.keys.should eq [] of String
        end
      end

    context "with no file" do
      it "raises IO Error" do
        expect_raises(IO::Error, "Please check the target file: No such file or directory") do
          xattr = XAttr.new("spec/not_there.txt")
          xattr.keys
        end
      end
    end
  end

  describe "remove" do
    it "removes the xattr from the target file" do
      file = File.touch(path)

      xattr = XAttr.new(path)
      xattr[key] = "mytag1"

      xattr.remove(key)

      xattr.keys.should eq [] of String
    end

    it "raise an exception if the target file is missing" do
      expect_raises(IO::Error, "Please check the target file: No such file or directory") do
        xattr = XAttr.new("spec/test_dir/not_there.txt")
        xattr.remove(key)
      end
    end
  end

  describe "to_h" do
    it " returns an hash map of attrs/values" do
      file = File.touch(path)

      xattr = XAttr.new(path)

      xattr[key] = "mytag1"
      xattr["user.xdg.comments"] = "foobar"

      xattr.to_h.should eq({"user.xdg.comments" => "foobar", "user.xdg.tags" => "mytag1"})
    end
  end
end
