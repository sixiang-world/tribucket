class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.94"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.94/CLIProxyAPI_7.2.94_darwin_aarch64.tar.gz"
      sha256 "e3be2bc37e115a73a1a5bb11f67e6ddb72f313c4377261312b7551e58b428cef"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.94/CLIProxyAPI_7.2.94_darwin_amd64.tar.gz"
      sha256 "5579d95319b1ec34766427ed7645e986cad443cb940c42542effd8bd56bb864b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.94/CLIProxyAPI_7.2.94_linux_aarch64.tar.gz"
      sha256 "5323f5f88175ccb245c84f8f08b8f3b5398e758467f2a9618b56f75c46acab08"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.94/CLIProxyAPI_7.2.94_linux_amd64.tar.gz"
      sha256 "2866539827f35eefa9b93267922d73bb316912262b13c5e19a69d28e9385f0db"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
