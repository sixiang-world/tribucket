class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.154"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.154/CLIProxyAPI_7.2.154_darwin_aarch64.tar.gz"
      sha256 "90645a2d71bf7247e06b517757b498d0d0306afa9c48173aae7e2a230df2d546"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.154/CLIProxyAPI_7.2.154_darwin_amd64.tar.gz"
      sha256 "62171996db7a9a2aa4ff00c68ba8255d7721790e34c6260f915631a9d44576e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.154/CLIProxyAPI_7.2.154_linux_aarch64.tar.gz"
      sha256 "3a0cd18d64e3b9990ca72136dbb1da97eedddade00ee6768e8b49fab1de6925e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.154/CLIProxyAPI_7.2.154_linux_amd64.tar.gz"
      sha256 "2a2256ceff048d5fa813aa54e8daa43e870b40e698d5cd21efad46e25aa5a1f9"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
