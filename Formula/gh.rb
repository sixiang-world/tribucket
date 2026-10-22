class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.103.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.103.0/gh_2.103.0_macOS_arm64.zip"
      sha256 "54be566e9f614bea5de8021e95b9ad33dfee3b9d2ea120c9c294c00defaa5014"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.103.0/gh_2.103.0_macOS_amd64.zip"
      sha256 "64d1734941f104f996271c820daa50e96902c2618f9b4c1e63c41519517a9c6b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.103.0/gh_2.103.0_linux_arm64.tar.gz"
      sha256 "7f322df34e624d14f5ec0c4acb121fd6dfa14392fdbbd1066aa8e0a05ac3721e"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.103.0/gh_2.103.0_linux_amd64.tar.gz"
      sha256 "fdd768eb70f6409f80fcfa9f3a1c0adf0fc98d827ab3ce0bed2ac22762c5d786"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
