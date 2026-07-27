class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.14.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.7/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "aaf5c61c0c29b35a205fe1cff590d900716ea61e7d7c5efc8a3ebfbf624a81a2"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.7/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "2ef391201ed2fc874a67e19aebd05fc289e0a75c0116fba14e93b48232223eca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.7/bottom_aarch64-linux-android.tar.gz"
      sha256 "c6e093fa57c3efd51f227e6db865d8848d83bc3c9f25127292205c183eddb311"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.7/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "60d772f8227793ef205c2bb52e396e26c328cd910e96026cd3009c3c68f37c27"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
