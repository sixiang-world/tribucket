class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.8/mise-v2026.8.8-macos-arm64.tar.gz"
      sha256 "770e15e821fd354496e728c11eb34a2b48bf7fee3dd444d09babcf64decea3aa"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.8/mise-v2026.8.8-macos-x64.tar.gz"
      sha256 "cc377641e601ee6c0429316b564052a86792651c1783c0f30114aa5265315caa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.8/mise-v2026.8.8-linux-arm64.tar.gz"
      sha256 "6e6e96d319fe274996db5aed691f5398552865e641dc4b6fb6b01d73f4853a17"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.8/mise-v2026.8.8-linux-x64.tar.gz"
      sha256 "58edfbdba6d4255b6536a61daeaf3b21f7a059430c789e948c8494ba32d59e1f"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
