class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.95.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.95.0/gh_2.95.0_macOS_arm64.zip"
      sha256 "3677f9c27965825f9c7d50395473c134edaea4b484373ef6b25de653570a0489"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.95.0/gh_2.95.0_macOS_amd64.zip"
      sha256 "985707e9ac60c95ed51cddd808c338b481abe69fffa77e9d6547c3750045f77e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.95.0/gh_2.95.0_linux_arm64.tar.gz"
      sha256 "d41e0b3b6218e5741c8bb4db39b16e53a59e0e06299a8489bd38f623ef7ebaae"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.95.0/gh_2.95.0_linux_amd64.tar.gz"
      sha256 "25d1e4729e8808c9ed3d613e96ebd3f3e44446f2d368c89d878a71a36ddb3d8c"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
