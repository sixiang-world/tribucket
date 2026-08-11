class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.128"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.128/CLIProxyAPI_7.2.128_darwin_aarch64.tar.gz"
      sha256 "b3906386761b4170118ea602376e70517f8058a27312a8c2a867f946ac6f789d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.128/CLIProxyAPI_7.2.128_darwin_amd64.tar.gz"
      sha256 "adfcf5d0d88ffd965077836e87dbf945a37e6327db0c48043264ef793fc54fea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.128/CLIProxyAPI_7.2.128_linux_aarch64.tar.gz"
      sha256 "fb97edc5f96287b8f8ee4b7138b6dbab550db343eb4d0bb92a8e16f98b9ebae1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.128/CLIProxyAPI_7.2.128_linux_amd64.tar.gz"
      sha256 "5feeef4bbe52f42fbc6f50135d42f4e0bcd9996870fdb22a76a972902d8c9006"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
