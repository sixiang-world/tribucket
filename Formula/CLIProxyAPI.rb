class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.132"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.132/CLIProxyAPI_7.2.132_darwin_aarch64.tar.gz"
      sha256 "360f410c7a30df1dc197949bfd2f272930a9420ce9357889c27b40d8ad9f17f9"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.132/CLIProxyAPI_7.2.132_darwin_amd64.tar.gz"
      sha256 "24c3f43ca36e45a1cd0f2bb91613208b3f155d6d8654c99dcda9ad8970f1fcd1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.132/CLIProxyAPI_7.2.132_linux_aarch64.tar.gz"
      sha256 "36aaa1a40916933d43ffa93ebea917cc8cd3d68db30b19c2296fc44dd33c3208"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.132/CLIProxyAPI_7.2.132_linux_amd64.tar.gz"
      sha256 "3813ec363ee53bd2ec6c876f8a6adf794a82247ca41a0994de8514a408888639"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
