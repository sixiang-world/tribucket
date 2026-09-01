class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.99.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.99.0/gh_2.99.0_macOS_arm64.zip"
      sha256 "94d4bd7e88563a9cb414e651e88acc4f1728a87476752460906d824230748d37"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.99.0/gh_2.99.0_macOS_amd64.zip"
      sha256 "70c05750c75df9465bc73b994e8bc379243bb494271f1b51f54ead2e19e45471"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.99.0/gh_2.99.0_linux_arm64.tar.gz"
      sha256 "564eff56a61e8caf193efde16937fba879eb62a3a479c9dd6be2001e7647680b"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.99.0/gh_2.99.0_linux_amd64.tar.gz"
      sha256 "ed4960225d2833e04a61590d9fa2b5773d147f3aa375459e5466a40c102f3832"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
