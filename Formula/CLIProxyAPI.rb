class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.14/CLIProxyAPI_7.3.14_darwin_aarch64.tar.gz"
      sha256 "ec45cffb882ef94f2c80b897767b376fea57e025ff28cef118453d58d4c83964"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.14/CLIProxyAPI_7.3.14_darwin_amd64.tar.gz"
      sha256 "b26eab8b7877a10e8a24e4ddcc136a3ea842914da7822985b2d36a9639a39e8b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.14/CLIProxyAPI_7.3.14_linux_aarch64.tar.gz"
      sha256 "741eb9296410e7b67df76aa8d33bd06297dd694c822983a1a72ee54b06e7f64d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.14/CLIProxyAPI_7.3.14_linux_amd64.tar.gz"
      sha256 "a93cdfb2e8b673eb362dedb0f0317ad3baf4d5eb2256da297239badb73c1d23d"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
