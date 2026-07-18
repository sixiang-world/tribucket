class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.88"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.88/CLIProxyAPI_7.2.88_darwin_aarch64.tar.gz"
      sha256 "9f9c3c33612fece39e5b99ddc9b09ce3510eb9e6b5be23aab238dbd9a06b4c9d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.88/CLIProxyAPI_7.2.88_darwin_amd64.tar.gz"
      sha256 "86452ee4e0f2f0ca25ff32c8c17d1aedb8ea9ad4679111e99a579e89afa54a1a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.88/CLIProxyAPI_7.2.88_linux_aarch64.tar.gz"
      sha256 "d8bec71bdc8bfa21bc1340b0794430297764c9f0739c00c4ad19cb78a1b0ff6c"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.88/CLIProxyAPI_7.2.88_linux_amd64.tar.gz"
      sha256 "2cc3b38e3ba2474d0cdeb7a3f25b026891ba34e34d3a7e0501d4efd03c01f6fe"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
