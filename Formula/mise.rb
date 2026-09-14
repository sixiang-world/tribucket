class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.7/mise-v2026.9.7-macos-arm64.tar.gz"
      sha256 "f6810aa1609a475ce7f3fdc83eb1e090ace6231d3b1b5aaead944663c4b4b7f1"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.7/mise-v2026.9.7-macos-x64.tar.gz"
      sha256 "98d6fa19fbf6022558ffbbf259800fc7f3dd696fdc950b922d7f3f53e75ef36b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.7/mise-v2026.9.7-linux-arm64.tar.gz"
      sha256 "d8d38909537af5864822f3ad545d48f1cefae15db266b20052a32da7f834fd50"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.7/mise-v2026.9.7-linux-x64.tar.gz"
      sha256 "6cc34785ae10c38061e569b64b290fc8ac26e94d12c3f1aeb721790fa8f09196"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
