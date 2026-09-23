class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.15/CLIProxyAPI_7.3.15_darwin_aarch64.tar.gz"
      sha256 "c1e49c148a94c476dc43a6a0eed28bca34239d5153ebb7792048d8c18f3b92f0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.15/CLIProxyAPI_7.3.15_darwin_amd64.tar.gz"
      sha256 "1dd2f2f5d57c2c9172eb51837d07f1f014d02ab1093215401a00c61d942bb972"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.15/CLIProxyAPI_7.3.15_linux_aarch64.tar.gz"
      sha256 "0b147342517b2f0f0cb80a4630e4f863cdd531fa0e90986f30a437c81ba82e75"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.15/CLIProxyAPI_7.3.15_linux_amd64.tar.gz"
      sha256 "801c3a23061d57a830e67fcd033fda26e96c2bfe93e1b2e34e4428ed7defc7e5"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
