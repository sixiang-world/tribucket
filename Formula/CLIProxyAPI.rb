class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.138"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.138/CLIProxyAPI_7.2.138_darwin_aarch64.tar.gz"
      sha256 "1a9cec1069f6b8d77c528b3c26ad6ac1690666ceaee4cafd800ddbb78cbe81a3"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.138/CLIProxyAPI_7.2.138_darwin_amd64.tar.gz"
      sha256 "cd41357b4d66809006ea6e131e0611308e4c3c23b1224dc6075b8f6628a19c6c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.138/CLIProxyAPI_7.2.138_linux_aarch64.tar.gz"
      sha256 "8dbb6b0c279737b7054e0e9dfb7d681a06e7034808e537fad288674c8fd52b3e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.138/CLIProxyAPI_7.2.138_linux_amd64.tar.gz"
      sha256 "8024a29ab228d6c263232b29eae76ef8aaf6efb05ee56848a2079aeda8f9a59c"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
