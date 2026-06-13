class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.75"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.75/CLIProxyAPI_7.1.75_darwin_aarch64.tar.gz"
      sha256 "3578aa207712a16bf8e22f0ec84fa0b77843a1aa7a9d664aafcc5806812d2040"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.75/CLIProxyAPI_7.1.75_darwin_amd64.tar.gz"
      sha256 "550ef3d6678920254f402b424983fd0b2868d7b13d7e847e0d915b85a14a59ce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.75/CLIProxyAPI_7.1.75_linux_aarch64.tar.gz"
      sha256 "853f47b3c4c5a09fd78ba00752b72094ea13c06c0e8378e13362b23bdb608868"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.75/CLIProxyAPI_7.1.75_linux_amd64.tar.gz"
      sha256 "46eb2b43fae0018593f5e009db5a332c234c62e5c46c9ef01881fe1f1e766b4c"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
