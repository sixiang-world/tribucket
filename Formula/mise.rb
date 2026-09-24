class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.13/mise-v2026.9.13-macos-arm64.tar.gz"
      sha256 "4698c2537eef78830bd5acf98204100fb0ad9a8884861e55265e855f35aa3fa0"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.13/mise-v2026.9.13-macos-x64.tar.gz"
      sha256 "1244981f542e39d3ceaa4a548d59b793c052f419db760e139839d47d17fae483"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.13/mise-v2026.9.13-linux-arm64.tar.gz"
      sha256 "0a9b8c243e717df2706e6822855ac8cfd5089745400565a815a93803cfcd4042"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.13/mise-v2026.9.13-linux-x64.tar.gz"
      sha256 "827c7997af2e0e5a418f266ead5df99ee4aae9b6fd435df8dbe79d90f335ff9a"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
