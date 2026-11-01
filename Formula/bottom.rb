class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.15.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.15.0/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "6d83c9eba811dd139392fa5b04baa75225c6aa120dad36a070e636660db023fd"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.15.0/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "6a7f5e32fc2c272256ad5c77aa8aaede02e1e86cf3ba4715acb894d3d6d5b361"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.15.0/bottom_aarch64-linux-android.tar.gz"
      sha256 "2cbf2ccc0ee85e826b40d453ff5a41192ee20f0b0d772ca526153cb5551ac75a"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.15.0/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "051888e0e064aa037728efed3fcf77820714f8f4dc7bea2b0179d40c54400c26"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
