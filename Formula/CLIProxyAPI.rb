class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.18/CLIProxyAPI_7.3.18_darwin_aarch64.tar.gz"
      sha256 "c051bf70d32496c64c6f1244085db2ec5debdbab9540335cdc33a0d25e63bcdd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.18/CLIProxyAPI_7.3.18_darwin_amd64.tar.gz"
      sha256 "a2afd18087788a24675079f4ed3cef1fbd9c92e1d01e36e7c7d71ae7e068e658"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.18/CLIProxyAPI_7.3.18_linux_aarch64.tar.gz"
      sha256 "eeae7e16fa8f86bd06be2993c637e70240903e52dd72fcc2a5c9fa2e6b327cee"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.18/CLIProxyAPI_7.3.18_linux_amd64.tar.gz"
      sha256 "f9441024eaa953fd19ad1ff191dbe29dcfbc6a70a53f712062d96f531803b766"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
