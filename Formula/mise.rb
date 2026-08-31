class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.15/mise-v2026.8.15-macos-arm64.tar.gz"
      sha256 "8b7729dc761e3118dd2910fe42fc74f720ca218a8131c1cc98dcd66ca111c2d5"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.15/mise-v2026.8.15-macos-x64.tar.gz"
      sha256 "64cf3737ab89e606f530f7e2b762e4b800bed423e2b9d7ff6a537603ddfc7644"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.15/mise-v2026.8.15-linux-arm64.tar.gz"
      sha256 "9c84ab84e4fc6cac8b66298ba13ab02eb630e100d86b2ab67b5bffdcb4c92c51"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.15/mise-v2026.8.15-linux-x64.tar.gz"
      sha256 "e3682d90f777d9e5940922169961aec2f3a61ad78f34c73ebbba34dfd2bc179c"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
