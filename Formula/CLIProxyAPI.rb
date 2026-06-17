class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.15/CLIProxyAPI_7.2.15_darwin_aarch64.tar.gz"
      sha256 "46e2821981c287a27c0f7631936ec5605efad20249fa7f0d2689c167f54b8337"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.15/CLIProxyAPI_7.2.15_darwin_amd64.tar.gz"
      sha256 "c743c946af742403d62e08b498c76ca46194524364bdd350d88237d81aafccb0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.15/CLIProxyAPI_7.2.15_linux_aarch64.tar.gz"
      sha256 "b2b4aec8e018ccee0f5fcf6ed311f2a64bf863e2600d0545f4e285ef7dc3299d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.15/CLIProxyAPI_7.2.15_linux_amd64.tar.gz"
      sha256 "c9283fd1fce3426832306d120400e345da7ce0abb6af793452d683db6cbffc40"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
