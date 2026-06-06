class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.47"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.47/CLIProxyAPI_7.1.47_darwin_aarch64.tar.gz"
      sha256 "1eda304d6daac549adf228193929de26b3de40cd3731d0ecc5c329962b0bb5ba"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.47/CLIProxyAPI_7.1.47_darwin_amd64.tar.gz"
      sha256 "69fe9b78ef8112f2b4e0bd7d3793608cb30cf3ec28655b9065080fe831d1e3e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.47/CLIProxyAPI_7.1.47_linux_aarch64.tar.gz"
      sha256 "5d374bef0216867de98f0b71644d5f9cdbe82ba9dfadfdb62f4320c513d29781"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.47/CLIProxyAPI_7.1.47_linux_amd64.tar.gz"
      sha256 "4fdf54b4e4d1d022bf9229a4199b5a0d9126f580161aac8406240cbc44f5eb87"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
