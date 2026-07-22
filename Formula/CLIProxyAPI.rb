class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.95"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.95/CLIProxyAPI_7.2.95_darwin_aarch64.tar.gz"
      sha256 "c7ccc28b7db5d1799999a9e22725ccc6bd0e36d9aa023da6b52b7c1a71aad978"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.95/CLIProxyAPI_7.2.95_darwin_amd64.tar.gz"
      sha256 "fbee90c29ee1047a8b3041d736500422bea22cd2ebb306782efcd74c0a10939c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.95/CLIProxyAPI_7.2.95_linux_aarch64.tar.gz"
      sha256 "acc1173c73db2a2ee203438bac9a956491855d4955c5175855abc62d12ae0184"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.95/CLIProxyAPI_7.2.95_linux_amd64.tar.gz"
      sha256 "826604e2dbf11913b0f373047f7bca1829eb2bab8a45d3a1916cc2534c7a9fd5"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
