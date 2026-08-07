class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.123"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.123/CLIProxyAPI_7.2.123_darwin_aarch64.tar.gz"
      sha256 "67b028f98c5e425f3e7410cfbf51bc6924d4e9323e4a0b107368422e3b8249af"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.123/CLIProxyAPI_7.2.123_darwin_amd64.tar.gz"
      sha256 "1ac6447ec9d90438a2cd5d58cbc5ea209f8c0693745b7aff09f9b103967db1c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.123/CLIProxyAPI_7.2.123_linux_aarch64.tar.gz"
      sha256 "578de70ac058445faa206c73f1d1069d63422a966b8b1dd3abc90f5ff023705a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.123/CLIProxyAPI_7.2.123_linux_amd64.tar.gz"
      sha256 "c02c70f85636c7c6971dc60e282ac9b31146d99e96e827e7ac3ab5701fa5bb49"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
