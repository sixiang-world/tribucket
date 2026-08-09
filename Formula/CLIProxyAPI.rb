class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.126"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.126/CLIProxyAPI_7.2.126_darwin_aarch64.tar.gz"
      sha256 "d1d24b559ad89d885c6a3bac3aac2682fa0798daaa049718c03de20eb2f6884a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.126/CLIProxyAPI_7.2.126_linux_aarch64.tar.gz"
      sha256 "0ae3293bcfb735e3e40f081dc20de0d285fecae0ca103c17b692d529ac1230d9"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
