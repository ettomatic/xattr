require "./spec_helper"

describe XAttr do
  key = "user.xdg.tags"
  describe ".get" do
    it "returns the tags assigned to a target file" do
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
  end
end
