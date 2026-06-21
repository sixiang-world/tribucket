class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.27"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.27/CLIProxyAPI_7.2.27_darwin_aarch64.tar.gz"
      sha256 "d00b58e4444f05d75b32aefb3b21aca8ca517ea31675f9acb00ce9a1ab1c228a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.27/CLIProxyAPI_7.2.27_darwin_amd64.tar.gz"
      sha256 "f6299479a262b9d397c92b53e6f0f2052064f6cb140f9cd75b8d9feeafca7c15"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.27/CLIProxyAPI_7.2.27_linux_aarch64.tar.gz"
      sha256 "834e367e6d014c7d269c18928f7b7112e4c0abc9d72a74036e447297d130043f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.27/CLIProxyAPI_7.2.27_linux_amd64.tar.gz"
      sha256 "f6ac224c073003f5f14ebf49476ade3415c2b67685ab4b89f6118828c7128ed4"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
