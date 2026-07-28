class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.103"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.103/CLIProxyAPI_7.2.103_darwin_aarch64.tar.gz"
      sha256 "2ca390dd6e4daf7b632bacf22a87000e52f3c626b180029827268c9dad240c1f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.103/CLIProxyAPI_7.2.103_darwin_amd64.tar.gz"
      sha256 "5a5cbd7cb5642b863a553ca7ee17c34ca6524bcf1898e0c5f3b1ac12ed68cd1e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.103/CLIProxyAPI_7.2.103_linux_aarch64.tar.gz"
      sha256 "134097d189c11c882a77bd72eb82b7beecc19545397b622954b4ff79fa8c4b43"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.103/CLIProxyAPI_7.2.103_linux_amd64.tar.gz"
      sha256 "c958621f8d09910db4159d65ff3d2fff8ece46f4d8b27a63ba291fbc96b264a7"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
