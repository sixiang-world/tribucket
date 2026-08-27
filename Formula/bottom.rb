class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.14.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.9/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "28358e19a3d62b3778fc0d1778b0028a682059145c9ac38ac5076bf124d77714"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.9/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "d0b1d446963ee3c4dfbfe2efd9614cfdc77f39e8268bf8cc2e0b5b6cea982774"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.9/bottom_aarch64-linux-android.tar.gz"
      sha256 "ab0962167505b8a56d7852952e17f1afeeb83f79ca21b5509ff0ba98c6ac4da1"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.9/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e0c325829e8bdcea25a8a7651da05dbb6f1fc109ac5d2f0187867d3d5d9c0df8"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
