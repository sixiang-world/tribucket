class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.73"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.73/CLIProxyAPI_7.1.73_darwin_aarch64.tar.gz"
      sha256 "79f6fb10272cb80beb5eb34c4f7f8fa76767776872562a781a293ef02cd1816b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.73/CLIProxyAPI_7.1.73_darwin_amd64.tar.gz"
      sha256 "cbde36cf3253c3e4d9c38352c5bc12f35532d8e4569fb41826320fe43c37d7e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.73/CLIProxyAPI_7.1.73_linux_aarch64.tar.gz"
      sha256 "0703f2b81d00a42b10ac7473dab23e983bdb2b58b90e122c4aa31b0fd2a2043e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.73/CLIProxyAPI_7.1.73_linux_amd64.tar.gz"
      sha256 "eb1462ebcb51e3aae848955fb7fddefbb7cba52e9255c02f8accb00aef329b78"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
