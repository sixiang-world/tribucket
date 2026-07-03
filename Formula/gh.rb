class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.96.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.96.0/gh_2.96.0_macOS_arm64.zip"
      sha256 "f23a0c37d963aacc3bed703ccbd59b41c5ca22101fab7f00eb2b7cad23aba463"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.96.0/gh_2.96.0_macOS_amd64.zip"
      sha256 "4bd449df9ad639391bc62b8032546f0fe9edcd8526e06682a4f88abd8c5d163c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.96.0/gh_2.96.0_linux_arm64.tar.gz"
      sha256 "06f86ec7103d41993b76cd78072f43595c34aaa56506d971d9860e67140bf909"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.96.0/gh_2.96.0_linux_amd64.tar.gz"
      sha256 "83d5c2ccad5498f58bf6368acb1ab32588cf43ab3a4b1c301bf36328b1c8bd60"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
