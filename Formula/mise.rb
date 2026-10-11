class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.8/mise-v2026.10.8-macos-arm64.tar.gz"
      sha256 "8228699f316dc17931beb86f7a1aac70e4685535430441492ff4e857c72535ad"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.8/mise-v2026.10.8-macos-x64.tar.gz"
      sha256 "28c924c5703c6344489bc73227c59da2194eaf7fd962c5f3d233b9524b7419e9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.8/mise-v2026.10.8-linux-arm64.tar.gz"
      sha256 "88aea77e41c2a3c45a9cbd64df9516ba887017442846213b3de178acbd3c9a46"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.8/mise-v2026.10.8-linux-x64.tar.gz"
      sha256 "e908ea27810ae358c9a9a7d897ea10197bdc38d39839243e1b36acc31cbef868"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
