class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.17/mise-v2026.9.17-macos-arm64.tar.gz"
      sha256 "63deaba3321800014feb6a92f1fed38680edf8deccbe972beebcdae7b67f3172"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.17/mise-v2026.9.17-macos-x64.tar.gz"
      sha256 "b287fd5edcbe5a488a7b63d88b48ec54b9bfeb2df9862a51ee889009444c6f5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.17/mise-v2026.9.17-linux-arm64.tar.gz"
      sha256 "46717187f93d4ebfff8b87a30da3f5939af995057c0c1a855e968f0ee4d19c88"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.17/mise-v2026.9.17-linux-x64.tar.gz"
      sha256 "8d1bcbc0b2ba167ee765e7410502c3f89974d0195eb8ec74537bc93bb367420d"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
