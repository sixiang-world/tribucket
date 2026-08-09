class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.125"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.125/CLIProxyAPI_7.2.125_darwin_aarch64.tar.gz"
      sha256 "885c313868e3b3414f31937c6506d46d0af9ad2870202f4ef45893dcdfa441aa"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.125/CLIProxyAPI_7.2.125_darwin_amd64.tar.gz"
      sha256 "6f15d46806a1cb3d882ec013f3e84d26070be48c20f02a6f570772c952ae77fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.125/CLIProxyAPI_7.2.125_linux_aarch64.tar.gz"
      sha256 "758bee4775442d3887eb9ef0553cd0ea22bc248e7043dd23b8a5a05581e04cc7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.125/CLIProxyAPI_7.2.125_linux_amd64.tar.gz"
      sha256 "4e940b7dc5bdf867b5c58ca30f1b368fae6dc2e041e8a351d5c2c07f3f610233"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
