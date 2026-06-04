class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.45"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.45/CLIProxyAPI_7.1.45_darwin_aarch64.tar.gz"
      sha256 "a16f9077c1a4e13808f7ec1909f4a1688a61f87119283faeb4cc29e0d2bbb340"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.45/CLIProxyAPI_7.1.45_darwin_amd64.tar.gz"
      sha256 "88e9c581a012bcb4ab67b6d03dfb0d97717be2bdeffdb91a757d4c6b6fe7030a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.45/CLIProxyAPI_7.1.45_linux_aarch64.tar.gz"
      sha256 "2d59cd4c17eefc9bb9e7563d4a219a88bff0c360c4b8ed1ef03a3d5e2e28836a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.45/CLIProxyAPI_7.1.45_linux_amd64.tar.gz"
      sha256 "6d056c16aa795a2aecc8433de1d6e4cc8ada2a8c71a931100f29def1b81e2a95"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
