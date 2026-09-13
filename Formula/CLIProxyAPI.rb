class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.0/CLIProxyAPI_7.3.0_darwin_aarch64.tar.gz"
      sha256 "8fe239443e6b7dc63187b3aa8f67056af0465af67788dacf5c63e802865c0017"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.0/CLIProxyAPI_7.3.0_darwin_amd64.tar.gz"
      sha256 "32deb8ff5d4516fc10affdeea886e52ae0c6e71dd4583a126305ea44b537591e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.0/CLIProxyAPI_7.3.0_linux_aarch64.tar.gz"
      sha256 "8b53610935e259a85e1858fef600c02c964a6e2cf017efb8cada61e91960a1e1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.0/CLIProxyAPI_7.3.0_linux_amd64.tar.gz"
      sha256 "577d4c9a98ee59f385ba6f53b136519668449120ff04735e74ad426f7db1950c"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
