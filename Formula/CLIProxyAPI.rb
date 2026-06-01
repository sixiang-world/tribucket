class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.37"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.37/CLIProxyAPI_7.1.37_darwin_aarch64.tar.gz"
      sha256 "e7c03866228011c83eeaa37b7df9f9a3412e8aca2296292770a7cab343e2208e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.37/CLIProxyAPI_7.1.37_darwin_amd64.tar.gz"
      sha256 "ec01814291ced8bd070fcb2d9fc5e2e3d092772ae081efa15ccbae15457c9b71"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.37/CLIProxyAPI_7.1.37_linux_aarch64.tar.gz"
      sha256 "0698a715b7d5c13ff599c9a505cd0a1ba9079cd12fff4846285d8e111001d067"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.37/CLIProxyAPI_7.1.37_linux_amd64.tar.gz"
      sha256 "8a1585d1a810c80d4068236b95685c55ff72bb1bdde56ee244f4608d41f06f4b"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
