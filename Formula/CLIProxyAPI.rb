class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.10/CLIProxyAPI_8.0.10_darwin_aarch64.tar.gz"
      sha256 "e2080f54ee4d7940c77345440956ce592eef34da2910bd865d4928b75accd122"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.10/CLIProxyAPI_8.0.10_darwin_amd64.tar.gz"
      sha256 "2d5af1cf19cc0d887b96fde809f78a999438a65564ce19de5966b7d5b6c451ca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.10/CLIProxyAPI_8.0.10_linux_aarch64.tar.gz"
      sha256 "80aa0615d5d538c1988542ab99bc2d9a7b46360814c0f8c93db9e30127e249ff"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.10/CLIProxyAPI_8.0.10_linux_amd64.tar.gz"
      sha256 "6211e059951e83acffedac098ad44a8bc60b47a53988c8d34d44397bfabbf578"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
