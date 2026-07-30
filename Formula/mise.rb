class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.17/mise-v2026.7.17-macos-arm64.tar.gz"
      sha256 "1c7afad0215f0e3055667feb249bbc6a35ad0bb72281c13b2bc1662f169a43b9"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.17/mise-v2026.7.17-macos-x64.tar.gz"
      sha256 "0ea28589dcb6e44d656af2e9dd301603b12e90af225ec691e53f7858b344adcb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.17/mise-v2026.7.17-linux-arm64.tar.gz"
      sha256 "2c41e54cec8a2e5063d2df5af9e065148de350550e9109ed57eb4d530158514f"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.17/mise-v2026.7.17-linux-x64.tar.gz"
      sha256 "30679f8b1f5ceaff322c39344645f71377c766dc35af0b792a26394795886fb9"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
