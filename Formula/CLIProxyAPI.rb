class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.76"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.76/CLIProxyAPI_7.1.76_darwin_aarch64.tar.gz"
      sha256 "06e86b7356fe8cd4e5b51e83009519a2def5b0b55f288572301758e5b7bcf58e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.76/CLIProxyAPI_7.1.76_darwin_amd64.tar.gz"
      sha256 "7da5e8459564c620dec4f5fb23bdebcf6c0f8dc2e35ec8d2457ce7ffc9e9f9c7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.76/CLIProxyAPI_7.1.76_linux_aarch64.tar.gz"
      sha256 "c8c0b81b8c145fa7c35e8c5f7f5cf9de09c41aed1991af2d8f29d1c88bdefbf0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.76/CLIProxyAPI_7.1.76_linux_amd64.tar.gz"
      sha256 "deb30849814a682389f5c79eb039d43b66de2a76b80fff7ebb69ab26ca823fac"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
