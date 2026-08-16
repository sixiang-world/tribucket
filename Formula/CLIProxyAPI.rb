class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.133"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.133/CLIProxyAPI_7.2.133_darwin_aarch64.tar.gz"
      sha256 "b538164f05fcf7ad0a11526e5d194b556366208e0a7ecaa74f9cd128a99905c7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.133/CLIProxyAPI_7.2.133_darwin_amd64.tar.gz"
      sha256 "72a7823424fc22435a7280215cb73727cfc8bee6cacc9a02b2665ba4ffe58416"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.133/CLIProxyAPI_7.2.133_linux_aarch64.tar.gz"
      sha256 "c12cc0ed7bb431522d6bad0a25e6b7da48e62af5a7b20c84fdaae2a099587ea8"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.133/CLIProxyAPI_7.2.133_linux_amd64.tar.gz"
      sha256 "18905ab269a7bcf7f8b89afa58ae5e289f16aac82aa9bd94ca7527990fb06e4a"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
