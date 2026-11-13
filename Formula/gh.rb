class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.104.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.104.0/gh_2.104.0_macOS_arm64.zip"
      sha256 "23b12706219b9892e44236f988444a24adcf29284e16b35e03ba5b863fb6eb8e"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.104.0/gh_2.104.0_macOS_amd64.zip"
      sha256 "a8c2a708dbae89dc7c05ba7b0beafc95bd8d09ab4a3505467b77d32ebf364dc6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.104.0/gh_2.104.0_linux_arm64.tar.gz"
      sha256 "cb34cefc6f4e77b90731374a2b737516bb8f3033c6ca46aa949e5344f68069e3"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.104.0/gh_2.104.0_linux_amd64.tar.gz"
      sha256 "98cb101ad87dbbd3f6b2f2bfcbd43197ccd07643140121d8a9cfaa91eadbc24e"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
