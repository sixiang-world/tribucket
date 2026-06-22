class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.14.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.1/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "1e7f03acb9189a4ad79c20fdef0bd7163265fa56ab75fc54b19f1dde5aaea5ae"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.1/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "762997cc95647c66176953595bbc4445a4c28ff7cb639889a9c9aa47ae2b5f24"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.1/bottom_aarch64-linux-android.tar.gz"
      sha256 "e46d6b9c6aab2634fc36bae51da2d355538e754c8bb3434a49254659a4031e18"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.1/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6fa44652759372054b5bc469a75c9bab38be37ff6bd087193a6c8f5855ede5dc"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
