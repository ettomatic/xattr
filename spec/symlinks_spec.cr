require "./spec_helper"

describe "symlinks" do
  key = "user.xdg.tags"
  path = __DIR__ + "/test_dir/test_get.txt"
  symlink_path = __DIR__ + "/test_dir/test_get_symlink.txt"

  context "on Linux" do
    before_each do
      Dir["spec/test_dir/*.txt"].each { |f| File.delete(f) }

      file = File.touch(path)
      symlink = File.symlink(path, symlink_path)
    end

    context "with no_follow set to true" do
      {% if flag?(:linux) %}
        it "raise an error if trying to set a xattr on a symlink" do
          File.symlink?(symlink_path).should be_true

          symlink_xattr = XAttr.new(symlink_path, no_follow: true)

          expect_raises(IO::Error, "Please check the target file: Operation not permitted") do
            symlink_xattr[key] = "mytag1"
          end
        end
      {% elsif flag?(:darwin) %}
        it "set the xattr on the symlink" do
          File.symlink?(symlink_path).should be_true

          symlink_xattr = XAttr.new(symlink_path, no_follow: true)
          symlink_xattr[key] = "mytag1"
          symlink_xattr.to_h.should eq({"user.xdg.tags" => "mytag1"})

          xattr = XAttr.new(path)
          xattr.to_h.should eq({} of String => String)
        end

        it "removes the xattr on the symlink" do
          File.symlink?(symlink_path).should be_true

          symlink_xattr = XAttr.new(symlink_path, no_follow: true)
          symlink_xattr[key] = "mytag1"
          symlink_xattr.to_h.should eq({"user.xdg.tags" => "mytag1"})

          xattr = XAttr.new(path)
          xattr.to_h.should eq({} of String => String)
        end
      {% end %}
    end

    context "with no_follow set to false (default behaviour)" do
      it "set the xattr on the symlinked file " do
        File.symlink?(symlink_path).should be_true

        symlink_xattr = XAttr.new(symlink_path, no_follow: false)
        symlink_xattr[key] = "mytag1"
        symlink_xattr[key].should eq "mytag1"

        xattr = XAttr.new(path)

        symlink_xattr.remove(key)
        symlink_xattr.keys.should eq [] of String

        xattr.keys.should eq [] of String
      end
    end
  end
end
