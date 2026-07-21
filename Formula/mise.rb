class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.11/mise-v2026.7.11-macos-arm64.tar.gz"
      sha256 "f1b6112a95b80d615a00ac349951a6e90a5638ab3c221a0125305391169f27bb"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.11/mise-v2026.7.11-macos-x64.tar.gz"
      sha256 "b8ba8f163c749f0f6d954145b4c424c164819218582b345700c52bad849e21fb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.11/mise-v2026.7.11-linux-arm64.tar.gz"
      sha256 "fca1ffa5fb7fc848f6af0be7aa45260b5a8507fc4f97b6b974a9d60ed9647817"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.11/mise-v2026.7.11-linux-x64.tar.gz"
      sha256 "6652ee5dd3bfa804a29355f7bb936134892bb9ac002b4cda172a44c67597cd0c"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
