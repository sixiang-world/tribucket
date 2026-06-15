class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.6/CLIProxyAPI_7.2.6_darwin_aarch64.tar.gz"
      sha256 "bf08b0b8253a80c9011fb4580ed7c0bec28b03caadd70c020b7fb84972f8c7ea"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.6/CLIProxyAPI_7.2.6_darwin_amd64.tar.gz"
      sha256 "c6711d4dee829adc2d3eb2f7479389b179c1a8c581e48ba07c1768eec1a10024"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.6/CLIProxyAPI_7.2.6_linux_aarch64.tar.gz"
      sha256 "7da7cd5c1aef71854269b9dadb7c0cb01fcc05b0249bbf3a15e22170a0fc5795"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.6/CLIProxyAPI_7.2.6_linux_amd64.tar.gz"
      sha256 "23a119c7492a8df6a313c9c7d1be7a38b92a526d6f038b8f78ebf3b480febf0b"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
