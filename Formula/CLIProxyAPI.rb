class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.117"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.117/CLIProxyAPI_7.2.117_darwin_aarch64.tar.gz"
      sha256 "3f7c5fb1720d6d05013161de35d38f647677b788a4c50f24ce1327c90de15819"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.117/CLIProxyAPI_7.2.117_darwin_amd64.tar.gz"
      sha256 "4a61438ec7ce1e3c980e1f900dd45fc620f914ff6e7549c3357c8fa42143ba78"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.117/CLIProxyAPI_7.2.117_linux_aarch64.tar.gz"
      sha256 "50ec1f2df21f107b8763a0d4ef608f4187dd0a97ec94f73e0ced6558c7057cdd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.117/CLIProxyAPI_7.2.117_linux_amd64.tar.gz"
      sha256 "e13e36d02d0f7fece1ad31e5aa2dd8b6ac4e0b22b82fd3d339843ce9948026fd"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
