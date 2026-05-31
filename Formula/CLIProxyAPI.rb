class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.33"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.33/CLIProxyAPI_7.1.33_darwin_aarch64.tar.gz"
      sha256 "d38fcbbd1450e455d1f0d355c56f3dc199b5927930e5900f8e050229dd5cc2e1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.33/CLIProxyAPI_7.1.33_darwin_amd64.tar.gz"
      sha256 "6ba8c27cd91df4e248e3ad49d1d02b0436775539ed2fffd2ed28137964a075cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.33/CLIProxyAPI_7.1.33_linux_aarch64.tar.gz"
      sha256 "bb710ba57eff35b21b91cec1810cc74af7328c8ac827a4719eea09e6acd59e4d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.33/CLIProxyAPI_7.1.33_linux_amd64.tar.gz"
      sha256 "8c30e19fd183b247add544e30c21921a7c1048a3e83d0c8fdbcddc72afd6022e"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
