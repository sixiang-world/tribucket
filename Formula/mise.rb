class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.11.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.8/mise-v2026.11.8-macos-arm64.tar.gz"
      sha256 "7a7f9342559cc4ca670054337ecf497e69d832a05f66e531628381dc92b88f48"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.8/mise-v2026.11.8-macos-x64.tar.gz"
      sha256 "355729a12f3d3b23059ad372855a82f5c8720d1d3fb63dbe5068bc9b4952201c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.8/mise-v2026.11.8-linux-arm64.tar.gz"
      sha256 "b36da3c4892380325d44dee3678ba618de191254d8a4aed8011ee66b28a6cbd7"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.8/mise-v2026.11.8-linux-x64.tar.gz"
      sha256 "d2d5a46f507bba772686e2c8f2316b3a4439dac49a37a30db5c0e7bb077c5431"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
