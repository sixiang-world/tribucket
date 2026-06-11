class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.94.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.94.0/gh_2.94.0_macOS_arm64.zip"
      sha256 "4f9bc1a5e77500737290a307b40b4c396a4d23729f55340f2a83f414410165a1"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.94.0/gh_2.94.0_macOS_amd64.zip"
      sha256 "733ee8fa49247d27cd94a6c7384455bdecaa82172a3bcfad63ac1ecc2867251d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.94.0/gh_2.94.0_linux_arm64.tar.gz"
      sha256 "705a23b70b0f1b7ba4c302fdcef392ce3edaacfa7ce8e85e4d93d72ea800a538"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.94.0/gh_2.94.0_linux_amd64.tar.gz"
      sha256 "a757f1ba6db18f4de8cbadb244843a5f89bc75b5e7c6fc127d2bd77fbd12ed62"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
