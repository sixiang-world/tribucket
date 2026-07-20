class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.92"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.92/CLIProxyAPI_7.2.92_darwin_aarch64.tar.gz"
      sha256 "fc9d2020c0961d097e0b8082d043006af534df261537a6a73756c6d60b4d6524"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.92/CLIProxyAPI_7.2.92_darwin_amd64.tar.gz"
      sha256 "7eb101925741b4080fe2fae3a7d630f41445c4fd5bf8174672dcaf1f637212b9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.92/CLIProxyAPI_7.2.92_linux_aarch64.tar.gz"
      sha256 "4cf0c1febc6a62e77181f5fa3fd334070a0d859d8824d51f7854aa50d52b98b1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.92/CLIProxyAPI_7.2.92_linux_amd64.tar.gz"
      sha256 "18ef0621b42bd12fd040789affa7d596343fea70359f59719c8c82d4f9ac0886"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
