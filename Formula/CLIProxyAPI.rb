class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.68"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.68/CLIProxyAPI_7.1.68_darwin_aarch64.tar.gz"
      sha256 "0766d59c375d166ec6f042a164e73c5ab405100fc5aed27353d9ea66212373d5"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.68/CLIProxyAPI_7.1.68_darwin_amd64.tar.gz"
      sha256 "68ecfbf7c780d6ed608d3fbd1ad36b4ac2084819e2e948077f207962be12f465"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.68/CLIProxyAPI_7.1.68_linux_aarch64.tar.gz"
      sha256 "db458627a3f1a236378d370a3bb71f37504895730f98f11fd4e424f2d11c40ef"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.68/CLIProxyAPI_7.1.68_linux_amd64.tar.gz"
      sha256 "58bb3504d7fcddd87b6153a825cf635af6dcab53d21ab812d6acf1d5e99c397f"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
