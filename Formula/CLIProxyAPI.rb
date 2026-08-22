class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.140"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.140/CLIProxyAPI_7.2.140_darwin_aarch64.tar.gz"
      sha256 "47aa529e29a75804283ad44206390e1c35b290e2c4e191739bd82759461ec7e7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.140/CLIProxyAPI_7.2.140_darwin_amd64.tar.gz"
      sha256 "a4adccf70ce97ffbc10f0f38cf19be21e7d5d651bbf336719769af635a786820"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.140/CLIProxyAPI_7.2.140_linux_aarch64.tar.gz"
      sha256 "f6a95b34be658f69e327113a342170beb0b400b726dbf0bc52b6758feb8081d1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.140/CLIProxyAPI_7.2.140_linux_amd64.tar.gz"
      sha256 "334b8417f0c24d2744700d63c10023c5b5d7c7c5b43b1609456432813ce713bf"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
