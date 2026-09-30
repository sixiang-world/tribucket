class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.102.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.102.0/gh_2.102.0_macOS_arm64.zip"
      sha256 "da922c20d1792e5b2cbf375593d7a658acf034c12c84e007e71c76ef959c337e"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.102.0/gh_2.102.0_macOS_amd64.zip"
      sha256 "b245f24eb2bf5f75b426b4c26da3651a107f8d5b6f4fddfbfccc5679041378b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.102.0/gh_2.102.0_linux_arm64.tar.gz"
      sha256 "7862c86c72f43df3a2d93ddde6f473285b4e2af61b494849846827e513ef6484"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.102.0/gh_2.102.0_linux_amd64.tar.gz"
      sha256 "bb766f710eef8ede859c18578c72c327597cd4c8a85b06001b1f3843c6019386"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
