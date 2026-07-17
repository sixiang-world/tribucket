class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.81"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.81/CLIProxyAPI_7.2.81_darwin_aarch64.tar.gz"
      sha256 "c48e80b51973f3102f7eac78c32be9bcfcde0dad48aa940d0bc2ee7052fa741a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.81/CLIProxyAPI_7.2.81_darwin_amd64.tar.gz"
      sha256 "75af5e17e4d211422d1dadf37dbfe715c2c8acad5b9784afe25ed5394e238376"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.81/CLIProxyAPI_7.2.81_linux_aarch64.tar.gz"
      sha256 "861a8fd33f6f57945d29e632ab4cca826a69649bc37be1fbccfaef0fd019f889"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.81/CLIProxyAPI_7.2.81_linux_amd64.tar.gz"
      sha256 "9a21b417e76c94267f747357bb83f87c8e9fccd5b15cbf8c3a8b3de1418a6472"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
