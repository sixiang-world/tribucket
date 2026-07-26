class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.101"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.101/CLIProxyAPI_7.2.101_darwin_aarch64.tar.gz"
      sha256 "5bcab7b61ad6b91da16eaac320e7fcd3447632a427b7b6c73631da064d445cab"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.101/CLIProxyAPI_7.2.101_darwin_amd64.tar.gz"
      sha256 "42fbdda0c0edb22b80a98617cb1cb328aab9c8559a8fb644adcb2b654c3685b0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.101/CLIProxyAPI_7.2.101_linux_aarch64.tar.gz"
      sha256 "70808dd71ef12480531fc427b3c28ef78a7c56b176450427937382ad2fb21b7a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.101/CLIProxyAPI_7.2.101_linux_amd64.tar.gz"
      sha256 "7f951c5e30e08a5219b386f793ff206712bc19941dc8b0c498aebbd5aa93e42e"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
