class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.7/CLIProxyAPI_8.0.7_darwin_aarch64.tar.gz"
      sha256 "817554e0eb9acf0a85d99deb54a355434deb2ed3f00cacc380a1085a48a4a40c"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.7/CLIProxyAPI_8.0.7_darwin_amd64.tar.gz"
      sha256 "e36b6133b7285930491ddd603257ec23b0aac7bfc710e641c1d90f64e709653b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.7/CLIProxyAPI_8.0.7_linux_aarch64.tar.gz"
      sha256 "ff991e63f55e944f4131f527d8459e28b914f7f96911c9b1965734f900e2584f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.7/CLIProxyAPI_8.0.7_linux_amd64.tar.gz"
      sha256 "89b97d522fb7dd7704545ef878ca61ceffe63bb166ee3156fe90576c1f443fb1"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
