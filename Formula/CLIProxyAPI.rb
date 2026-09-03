class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.148"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.148/CLIProxyAPI_7.2.148_darwin_aarch64.tar.gz"
      sha256 "e94dc0d424ff9ca51db447c5818d7bed0f1c2c8f6fd18fb3c6bb161e2f903ecc"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.148/CLIProxyAPI_7.2.148_darwin_amd64.tar.gz"
      sha256 "9b31d594f3cbebc1a350ddff45fba6521b38aa0b0851b3c59edf0448c934feb6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.148/CLIProxyAPI_7.2.148_linux_aarch64.tar.gz"
      sha256 "76b8d5d64a281a12138562dad5d4349fee7094a288f38999bc4f6a71c45affd1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.148/CLIProxyAPI_7.2.148_linux_amd64.tar.gz"
      sha256 "31fa4cbea733869feab38ad4dd604b42001b352ba5267a4a6994d762fd243e33"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
