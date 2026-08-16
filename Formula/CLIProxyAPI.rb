class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.134"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.134/CLIProxyAPI_7.2.134_darwin_aarch64.tar.gz"
      sha256 "772ab2dcacaaba12478baad08ee07ec1aa0c12b0d73483b92dd6990cceceb3b0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.134/CLIProxyAPI_7.2.134_darwin_amd64.tar.gz"
      sha256 "8647f314abfb1475374e0891c315797d13f1ecf2604d9699c22e3e078af6d572"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.134/CLIProxyAPI_7.2.134_linux_aarch64.tar.gz"
      sha256 "f31efc0033d7bcecef4135e66e658e1bd9d212f1ff76a16b09e85ff770f5620f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.134/CLIProxyAPI_7.2.134_linux_amd64.tar.gz"
      sha256 "8474b36dffde7e6fd63cdaf47186f7a89b9f4f4900d812292a99da84e7c5fa26"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
