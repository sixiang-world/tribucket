class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.20"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.20/CLIProxyAPI_7.2.20_darwin_aarch64.tar.gz"
      sha256 "97ca1485cbcb88cb2f0bee057cb6c9b81a0daec6cb209a079b6fab82a3ab0c38"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.20/CLIProxyAPI_7.2.20_darwin_amd64.tar.gz"
      sha256 "852780092563ada78503a10a317eb54e21af6c89a7479dff251fe3fda7b4935d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.20/CLIProxyAPI_7.2.20_linux_aarch64.tar.gz"
      sha256 "71bc14a1bb09822be7a2056889b2372dc6dbcc3896885fed770dc135bb7892b6"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.20/CLIProxyAPI_7.2.20_linux_amd64.tar.gz"
      sha256 "b510b0a90e383ab091d216ab40f6de61e7cf5cf4ce906baf84c4fa818753af87"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
