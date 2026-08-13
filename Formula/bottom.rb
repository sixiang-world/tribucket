class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.14.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.8/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "60138a19944eeb8cb177fea4f4d6d042d3971828de0418b034618d6837d62c1a"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.8/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "3d7b137934b4e88ecbed3c6f17d15115ca892863198d21ce890b885c3362ca95"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.8/bottom_aarch64-linux-android.tar.gz"
      sha256 "c7cdb6e9e138754129cef46158f55394cdb78431fcd4677bedd886af10934e2b"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.8/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1e29fb2b0230c8285665d107fc370493e61369433d9e0b9398f6bec19624fa50"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
