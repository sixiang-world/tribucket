class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.97"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.97/CLIProxyAPI_7.2.97_darwin_aarch64.tar.gz"
      sha256 "be064fec2d5cb253d8f8c20de62e18e791072546bd4ae7bd1e413a333895aa71"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.97/CLIProxyAPI_7.2.97_darwin_amd64.tar.gz"
      sha256 "4baa52f90e768b8572c37839b5affbbcc17ebb0f152837d08ad20eec094cbf70"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.97/CLIProxyAPI_7.2.97_linux_aarch64.tar.gz"
      sha256 "f58bc5509e912d88e4c8fcab8f967ee896800f8c8222b7893a6e958a902006a5"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.97/CLIProxyAPI_7.2.97_linux_amd64.tar.gz"
      sha256 "9de7d78769bd5aa28901ef18766c65c41fdb750258a5b318112de02928016ed4"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
