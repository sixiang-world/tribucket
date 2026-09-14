class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.3/CLIProxyAPI_7.3.3_darwin_aarch64.tar.gz"
      sha256 "f142744581a97888425c2e2d728dc3dc1478a02eac314913ec067ae144f7ae78"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.3/CLIProxyAPI_7.3.3_darwin_amd64.tar.gz"
      sha256 "7983b5253879c4d32f99e9a7658add9182e3789b8709ec0752436c58a95ae3e7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.3/CLIProxyAPI_7.3.3_linux_aarch64.tar.gz"
      sha256 "5f320e3fae52af00f07b78201311e9d096b36e759441d948de48a10f49e71883"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.3/CLIProxyAPI_7.3.3_linux_amd64.tar.gz"
      sha256 "7af8c99cd08eee3ccc81d1596e8a31785674d3de6bd7ec61416d59493dd8fc01"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
