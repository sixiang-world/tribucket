class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.0/mise-v2026.11.0-macos-arm64.tar.gz"
      sha256 "9c3678b20515f091208b3a2a9900bbc5ab7f228a1c5893849f0f2939b1829df3"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.0/mise-v2026.11.0-macos-x64.tar.gz"
      sha256 "8d5caf1b2a2ea6064795274c6a52c9d8f57c0924485a5a97238a3a571bd43566"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.0/mise-v2026.11.0-linux-arm64.tar.gz"
      sha256 "92f90c094b6eab2dcdbc46f2b977a78bba82a9311fe0c592c17e403a8d0ec621"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.0/mise-v2026.11.0-linux-x64.tar.gz"
      sha256 "cf48795ee2cb3f8822ba0ed4b45d729b791fe0c984baf6080ebb7b0c1ba23119"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
