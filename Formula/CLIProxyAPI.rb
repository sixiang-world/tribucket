class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.121"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.121/CLIProxyAPI_7.2.121_darwin_aarch64.tar.gz"
      sha256 "e18b22b873e5d17f317540e8c68db1ce6e8151ec85df8ee29d9cf4c8f93797c4"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.121/CLIProxyAPI_7.2.121_darwin_amd64.tar.gz"
      sha256 "7cd0deaf83a501b1b1504edc4865d50a409f840160a06454ac4b0d0b226c1005"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.121/CLIProxyAPI_7.2.121_linux_aarch64.tar.gz"
      sha256 "c9c19ec35be712bfe60bd727ee8800927072928d2bcb1c78e0bb7e30134a821b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.121/CLIProxyAPI_7.2.121_linux_amd64.tar.gz"
      sha256 "2a935841bfcc66e1965dd68aaeb65299633d69de59b8be09ce56136484812bee"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
