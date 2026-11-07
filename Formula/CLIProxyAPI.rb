class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.59"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.59/CLIProxyAPI_8.0.59_darwin_aarch64.tar.gz"
      sha256 "70adbaf210d8e576c481a937823acc7dcbf7a1e37b895f070c0bb81c8231ff38"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.59/CLIProxyAPI_8.0.59_darwin_amd64.tar.gz"
      sha256 "4d6f88603ec49890a9f90e50e87c99edeca76ec04ae273183966e1f9b4950922"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.59/CLIProxyAPI_8.0.59_linux_aarch64.tar.gz"
      sha256 "9cc54a52f2319a9aab4b902117fcd4cfd59cbb8748d8587327006f4c8c19efdc"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.59/CLIProxyAPI_8.0.59_linux_amd64.tar.gz"
      sha256 "5427e41344a8d57519156ae12b01654c2aef36ced39f493e327362e15627e34c"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
