class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.137"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.137/CLIProxyAPI_7.2.137_darwin_aarch64.tar.gz"
      sha256 "154a8d19b397dc1558b3c5bc660ea34136ce2591d90ba1243672c0d610a9268d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.137/CLIProxyAPI_7.2.137_darwin_amd64.tar.gz"
      sha256 "202cca09460c548d7e8a88b261fd7def09378b6064b2c631df7ca80a2764d32b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.137/CLIProxyAPI_7.2.137_linux_aarch64.tar.gz"
      sha256 "1c01e7389a29cdb865f73c69408605374841b3e6663e34a24126cd995dd915b6"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.137/CLIProxyAPI_7.2.137_linux_amd64.tar.gz"
      sha256 "ae68c776e124dbc8c8c5b86c501fc6906efa180cc5e35383adb26d05c2c91401"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
