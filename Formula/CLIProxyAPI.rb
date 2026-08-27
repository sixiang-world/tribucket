class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.144"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.144/CLIProxyAPI_7.2.144_darwin_aarch64.tar.gz"
      sha256 "9a4b7d0d1166ee5a1a5a9902d9b23aa47712a967ad6124ae50cbee11fe7d5a65"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.144/CLIProxyAPI_7.2.144_darwin_amd64.tar.gz"
      sha256 "a38f1e2b12f2279ce06febff4b535d7a8b212e46af967b8257003ae6273a7b0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.144/CLIProxyAPI_7.2.144_linux_aarch64.tar.gz"
      sha256 "2485871d6b683c6edfd5ab1e9188166628a5e0ccb1ec76f5b1f2e7efb3fc8151"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.144/CLIProxyAPI_7.2.144_linux_amd64.tar.gz"
      sha256 "02be1ad96791f1d2b7e6574bb0f68a3d75622e42cba07fecd012e575ba4b2a96"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
