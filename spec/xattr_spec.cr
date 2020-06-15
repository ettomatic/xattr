require "./spec_helper"

describe XAttr do
  key = "user.xdg.tags"

  describe ".get" do
    it "returns the specific xattr value assigned to a target file" do
      path = "spec/test_get.txt"
      file = File.touch(path)

      XAttr.get(path, key).should eq nil
      File.delete(path)
    end
  end

  describe ".set" do
    it "sets a value to the target file" do
      path = "spec/test_set.txt"
      file = File.touch(path)

      XAttr.set(path, key, "mytag1")
      XAttr.get(path, key).should eq "mytag1"

      File.delete(path)
    end

    it "overrides existing value" do
      path = "spec/test_set.txt"
      file = File.touch(path)

      XAttr.set(path, key, "mytag1")
      XAttr.get(path, key).should eq "mytag1"

      XAttr.set(path, key, "mytag2")
      XAttr.get(path, key).should eq "mytag2"

      File.delete(path)
    end

    it "raise an exception if the target file is missing" do
      expect_raises(IO::Error, "ENOENT - please check the target file") do
        XAttr.set("spec/not_there.txt", key, "mytag1")
      end
    end
  end

  describe ".list" do
    context "with xattrs set on the target file" do
      it "returns the attrs assigned to a target file" do
        path = "spec/test_list.txt"
        file = File.touch(path)
        XAttr.set(path, key, "mytag1")
        XAttr.set(path, "user.xdg.comments", "foobar")

        XAttr.list(path).should eq ["user.xdg.tags", "user.xdg.comments"]

        File.delete(path)
      end
    end

    context "with no xattrs set on the file" do
      it "returns the attrs assigned to a target file" do
        path = "spec/test_list.txt"
        file = File.touch(path)

        XAttr.list(path).should eq [] of String

        File.delete(path)
      end
    end
  end
end
