class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.98.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_macOS_arm64.zip"
      sha256 "8cfb027cc5310675f2b830eac8f9865c1155a45ffcf9757f699fdd5a22046ca4"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_macOS_amd64.zip"
      sha256 "734c7bbd0bc56a3974500ee9aea74d60f0e5b89be09e92b9d9148939a3a1e0e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_linux_arm64.tar.gz"
      sha256 "cf689084f3a3618f7eae4a2420d335d74626d65f5e594b9828d125d69f800d86"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_linux_amd64.tar.gz"
      sha256 "3b8ac6b30336802fc1a858d7c084e11cdf24ac1a761ca90b68022d7d729208de"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
