class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.29"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.29/CLIProxyAPI_7.2.29_darwin_aarch64.tar.gz"
      sha256 "37ec9976edf3ffd297a7e60cb62f918f08b3afbd3960ce3f913f3028d82eca4e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.29/CLIProxyAPI_7.2.29_darwin_amd64.tar.gz"
      sha256 "b4a25f1f599edfb19c08782aa9d1f802d93ebc104d563988d2ee406cac42eb29"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.29/CLIProxyAPI_7.2.29_linux_aarch64.tar.gz"
      sha256 "4e67d62da1e18edabaa4777d0336b8b1a6c78505e4303d0ecb369def80d29044"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.29/CLIProxyAPI_7.2.29_linux_amd64.tar.gz"
      sha256 "2d897e59b92a4edd142b28d1763a9fbf19f2271a606a0713c1b04a7a5a56809f"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
