class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.101.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.101.0/gh_2.101.0_macOS_arm64.zip"
      sha256 "e4303e39d8f07141c4bad4b99b01079f05029c59b27076e8fbc825c985ecdd8b"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.101.0/gh_2.101.0_macOS_amd64.zip"
      sha256 "a6fd66c88e2f07d6e4e058173db341d07dd74d58cf8f19ae668293d2bb614ca3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.101.0/gh_2.101.0_linux_arm64.tar.gz"
      sha256 "b57e8063f18862647c9d22727c32e9da1b963f8bf9db648fe123a6975695640f"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.101.0/gh_2.101.0_linux_amd64.tar.gz"
      sha256 "9bca2d1c16825f109907a23307628a2f0698fbf99662b73a5cf0b020293072b8"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
