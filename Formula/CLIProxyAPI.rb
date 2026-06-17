class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.14/CLIProxyAPI_7.2.14_darwin_aarch64.tar.gz"
      sha256 "e1a4535e67c8103da513ee4ede2dce24b6f85a819977378be270231866ad14a3"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.14/CLIProxyAPI_7.2.14_darwin_amd64.tar.gz"
      sha256 "934033b1c856f0ec93f12f4612db5734d2d3ae38d00bb3534ba189e2c4ff6e59"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.14/CLIProxyAPI_7.2.14_linux_aarch64.tar.gz"
      sha256 "8e071f95d054a7496c771a862b0553163113c5911622ea6682569514b43d5452"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.14/CLIProxyAPI_7.2.14_linux_amd64.tar.gz"
      sha256 "13b6872da7641b0f5f0383b968f0a42bddc5c53a915c73b7c811146472c47671"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
