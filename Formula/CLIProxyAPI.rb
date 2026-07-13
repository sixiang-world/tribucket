class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.72"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.72/CLIProxyAPI_7.2.72_darwin_aarch64.tar.gz"
      sha256 "e558b0dfe885aa40fa3777718849953824bd4461daf2e1e34affb2566cfa8df1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.72/CLIProxyAPI_7.2.72_darwin_amd64.tar.gz"
      sha256 "2845e45ce5b47db9d6d2b4fe169f2fc1c6f84cd2c7b5e19e748a05ef4be9ed5e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.72/CLIProxyAPI_7.2.72_linux_aarch64.tar.gz"
      sha256 "f89608d1c250d5932df645ee7835ef5b14cc98aea2575693ee2d7b86c6d65a7b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.72/CLIProxyAPI_7.2.72_linux_amd64.tar.gz"
      sha256 "bd1dee72c836e0fdc2f4833d6b628332500b84daf3bcd2d5afcf9ac7fa31db66"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
