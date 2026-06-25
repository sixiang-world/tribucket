class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.41"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.41/CLIProxyAPI_7.2.41_darwin_aarch64.tar.gz"
      sha256 "e21ebb75f93752042971503864c343d2232b527187373b5293ad65a6f4f6d708"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.41/CLIProxyAPI_7.2.41_darwin_amd64.tar.gz"
      sha256 "a41abed93d58e57372cafceee257204912a2d88c8deedc965c9d5e97cdda1ef5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.41/CLIProxyAPI_7.2.41_linux_aarch64.tar.gz"
      sha256 "c4f15718e9a2e3d4b13e8b911327ff7f109c54cd2f23bb056769a411e8654ed7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.41/CLIProxyAPI_7.2.41_linux_amd64.tar.gz"
      sha256 "301ca071d16569cf383b197ead6c32a12f84655662c860df5baf39fa270a6f6c"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
