class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.14.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.4/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "26133f4dffdda2ba019e50766e4ecbba877043c75625d9eddb2b701416b3a4c6"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.4/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "4e6b3a4b5e262708c8a0023d2914d38cb63f8a44aa9ab0284d4f52c2e85d6226"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.4/bottom_aarch64-linux-android.tar.gz"
      sha256 "d79d50cbaa3851260ba4e7810b7c50d29cd92cca71bb9b0065d5c8cdbbded255"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.4/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cb821b7a0d4203eba3cb6eaf1c3a4ebf19b50a9b47052f8afd0afa05ce7a5ddf"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
