class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.64"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.64/CLIProxyAPI_7.1.64_darwin_aarch64.tar.gz"
      sha256 "5b1d3626f1f8c567d52f3bdd8e3bf8845e21fa6cd468e41d7a1fb201b280f402"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.64/CLIProxyAPI_7.1.64_darwin_amd64.tar.gz"
      sha256 "590216be0331aa5f297ef5b037621b7c62afa41c3d1c992daae52d7445108081"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.64/CLIProxyAPI_7.1.64_linux_aarch64.tar.gz"
      sha256 "d12e62ee0c60a5174b305996f2dd8b1cdebd914cbf17e9f94e1aae2c020fa6b1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.64/CLIProxyAPI_7.1.64_linux_amd64.tar.gz"
      sha256 "230cf3a0505ea633f50cbea20c6369f4976075fd19b2ca69ff2263909216815e"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
