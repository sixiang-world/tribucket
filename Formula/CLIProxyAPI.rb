class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.147"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.147/CLIProxyAPI_7.2.147_darwin_aarch64.tar.gz"
      sha256 "4ac1db83b00591265ebb93a3277d812aaf6e45e8b21bb3b4786598520afdf4be"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.147/CLIProxyAPI_7.2.147_darwin_amd64.tar.gz"
      sha256 "85fd7332058f5ddedd0133d7e9063f02e80a1df60121ad515bab7aeb0e644af3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.147/CLIProxyAPI_7.2.147_linux_aarch64.tar.gz"
      sha256 "f3c59c38fc19f8e06042f29701ec9409dcc2b2235b5dc0a3ec142ba20b3a5a86"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.147/CLIProxyAPI_7.2.147_linux_amd64.tar.gz"
      sha256 "01dce9e9418bf85e64597132ecb53e82248782ad782feeea725e5bacdfb2f64f"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
