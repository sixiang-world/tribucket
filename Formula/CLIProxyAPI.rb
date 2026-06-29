class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.45"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.45/CLIProxyAPI_7.2.45_darwin_aarch64.tar.gz"
      sha256 "f93ddea53a9dab2062bf180d5c05e661e5b2b08b196d3068a4a32ffd86c17bfa"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.45/CLIProxyAPI_7.2.45_darwin_amd64.tar.gz"
      sha256 "3574f9718a7764225903cd76a0e5e8386662020df70ffff925b81fd16de1cf14"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.45/CLIProxyAPI_7.2.45_linux_aarch64.tar.gz"
      sha256 "ae997cf284d9e899aebffd6b2a7d2621a5a1ea81c279397d030ded37f35b4975"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.45/CLIProxyAPI_7.2.45_linux_amd64.tar.gz"
      sha256 "37dc8802a3f68f6da45619578162181ca5d23a6f0fc0f1d0c6fc613058b4a7ed"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
