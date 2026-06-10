class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.62"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.62/CLIProxyAPI_7.1.62_darwin_aarch64.tar.gz"
      sha256 "7f1c37b619dfe1c31ce1f04ca67863c84cd4537c5c3ad285751bc8c520b7f6b2"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.62/CLIProxyAPI_7.1.62_darwin_amd64.tar.gz"
      sha256 "8fd725d0114680f7296094a37e2c3e79d58de28cdd8eaa77dc825130eec62aaf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.62/CLIProxyAPI_7.1.62_linux_aarch64.tar.gz"
      sha256 "9e5f1e2dde887478be4b70f7ffe19e3825bc3b853f0bf2264318002cfcfb380c"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.62/CLIProxyAPI_7.1.62_linux_amd64.tar.gz"
      sha256 "d07d42bf913c05d35cc35cb7a7cfda7c288726b05d2bf9a3387d15f7da2f8d9c"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
