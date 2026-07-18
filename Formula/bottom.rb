class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.14.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.5/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "a39bde80615954489f08960bf48292b733e57e2dd141e2f4d61a12f11a7461c0"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.5/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "fd901f6fa441386911100a905d7ecb288f3934cf28a04e3c4cade4eebfac8570"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.5/bottom_aarch64-linux-android.tar.gz"
      sha256 "5ac85f67b807e60e6d89082000fa85afe12f4f609b97f0d0d8859a062b4e03a4"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.5/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "004a9cc1c5f71f07bbe0a35969596d8308f2ee4edcd55a77d0c3f1fc5c59eb7d"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
