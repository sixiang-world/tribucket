class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.76"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.76/CLIProxyAPI_7.2.76_darwin_aarch64.tar.gz"
      sha256 "6c088e75de34d0aee8ccbb9200bd6155f8cabb3ce4318ad486f2b0b0f24b98ce"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.76/CLIProxyAPI_7.2.76_darwin_amd64.tar.gz"
      sha256 "7b424e9ee4b00fa5369c43addb0618f45ceacc352b8398a0d3460e098f964bd6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.76/CLIProxyAPI_7.2.76_linux_aarch64.tar.gz"
      sha256 "35b065b92512d9d6f199366a30f2a45bb9880a25ff3fec3afeded2506e6e5d6e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.76/CLIProxyAPI_7.2.76_linux_amd64.tar.gz"
      sha256 "f75e18621a0afc6367ad6424c9a1faed157e22b3bac07e04c02406c2b25c9df0"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
