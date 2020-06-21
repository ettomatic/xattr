require "./spec_helper"

describe XAttr do
  key = "user.xdg.tags"

  describe "get" do
    it "returns the specific xattr value assigned to a target file" do
      path = "spec/test_get.txt"
      file = File.touch(path)

      xattr = XAttr.new(path)
      xattr[key] = "mytag1"
      xattr[key].should eq "mytag1"

      File.delete(path)
    end

    it "returns nil if xattr is not set" do
      path = "spec/test_get.txt"
      file = File.touch(path)

      xattr = XAttr.new(path)
      xattr["foo"].should eq nil

      File.delete(path)
    end

    it "returns nil if target file is missing" do
      xattr = XAttr.new("spec/not_there.txt")
      xattr[key].should eq nil
    end
  end

  describe "set" do
    it "sets a value to the target file" do
      path = "spec/test_set.txt"
      file = File.touch(path)

      xattr = XAttr.new(path)
      xattr[key] = "mytag1"
      xattr[key].should eq "mytag1"

      File.delete(path)
    end

    it "overrides existing value" do
      path = "spec/test_set.txt"
      file = File.touch(path)

      xattr = XAttr.new(path)

      xattr[key] = "mytag1"
      xattr[key].should eq "mytag1"

      xattr[key] = "mytag2"
      xattr[key].should eq "mytag2"

      File.delete(path)
    end

    it "raise an exception if the target file is missing" do
      expect_raises(IO::Error, "Please check the target file: No such file or directory") do
        xattr = XAttr.new("spec/not_there.txt")
        xattr[key] = "mytag1"
      end
    end
  end

  describe "list" do
    context "with xattrs set on the target file" do
      it "returns the attrs assigned to a target file sorted alphabetically" do
        path = "spec/test_list.txt"
        file = File.touch(path)

        xattr = XAttr.new(path)

        xattr[key] = "mytag1"
        xattr["user.xdg.comments"] = "foobar"

        xattr.list.should eq ["user.xdg.comments", "user.xdg.tags"]

        File.delete(path)
      end
    end

    context "with no xattrs set on the file" do
      it "returns an empty array" do
        path = "spec/test_list.txt"
        file = File.touch(path)

        xattr = XAttr.new(path)
        xattr.list.should eq [] of String

        File.delete(path)
      end
    end

    context "with no file" do
      it "returns an empty array" do
        xattr = XAttr.new("spec/not_there.txt")
        xattr.list.should eq [] of String
      end
    end
  end

  describe "remove" do
    it "removes the xattr from the target file" do
      path = "spec/test_remove.txt"
      file = File.touch(path)

      xattr = XAttr.new(path)
      xattr[key] = "mytag1"

      xattr.remove(key)

      xattr.list.should eq [] of String
      File.delete(path)
    end

    it "raise an exception if the target file is missing" do
      expect_raises(IO::Error, "Please check the target file: No such file or directory") do
        xattr = XAttr.new("spec/not_there.txt")
        xattr.remove(key)
      end
    end
  end

  describe "to_h" do
    it " returns an hash map of attrs/values" do
      path = "spec/test_hash.txt"
      file = File.touch(path)

      xattr = XAttr.new(path)

      xattr[key] = "mytag1"
      xattr["user.xdg.comments"] = "foobar"

      xattr.to_h.should eq({"user.xdg.comments" => "foobar", "user.xdg.tags" => "mytag1"})
    end
  end
end
