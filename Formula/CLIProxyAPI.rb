class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.61"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.61/CLIProxyAPI_7.1.61_darwin_aarch64.tar.gz"
      sha256 "3806d79cf9e36b6652709c6223b61d437e0d88adea35427a65b7c873e8b5860a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.61/CLIProxyAPI_7.1.61_darwin_amd64.tar.gz"
      sha256 "aac2f9c9b9a1371da11e5bbede1386df6b4f7bc05346f7cb1cfdadd18e68974d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.61/CLIProxyAPI_7.1.61_linux_aarch64.tar.gz"
      sha256 "164a472d4ac4ad79fcf57304d59a63d0701091680393d3e61a8bbcbb1c847f4a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.61/CLIProxyAPI_7.1.61_linux_amd64.tar.gz"
      sha256 "5f9696a9b81c7d001ea19ea928c6120644b43b69fa97bd9021cdb2de5a316a23"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
