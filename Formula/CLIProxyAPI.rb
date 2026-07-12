class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.69"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.69/CLIProxyAPI_7.2.69_darwin_aarch64.tar.gz"
      sha256 "8567fa6b999a670adf88b9f55b1bdbb3f9a2c59b98e6684f165d62d44393d206"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.69/CLIProxyAPI_7.2.69_darwin_amd64.tar.gz"
      sha256 "275042946b2bd3eb7f094bd92bcbcfa08b9b9f1d7b423b81cf5adff328720996"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.69/CLIProxyAPI_7.2.69_linux_aarch64.tar.gz"
      sha256 "54f92cbd16a1f7d8d5dad2622ca5426f3c5a816a3f7332226dbd7ef14e156276"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.69/CLIProxyAPI_7.2.69_linux_amd64.tar.gz"
      sha256 "5b48840f78bf303da86cc880da47f8e6316ab09ceef5ae0cda969a63ca5289a5"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
