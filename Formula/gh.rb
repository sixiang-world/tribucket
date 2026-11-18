class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.105.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.105.0/gh_2.105.0_macOS_arm64.zip"
      sha256 "2a5d03103ae444927383b93d9ffd65579a26e2eb900ce1cf11f55258d5319ded"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.105.0/gh_2.105.0_macOS_amd64.zip"
      sha256 "23602cbccbbdc6285a8520745b714cb927ce2ca621779373c2a20cd8e33fda66"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.105.0/gh_2.105.0_linux_arm64.tar.gz"
      sha256 "b1278c75107423d818f1937fd92cafc9e5e9b606631568f68d7fb816f5885a02"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.105.0/gh_2.105.0_linux_amd64.tar.gz"
      sha256 "79e7ab5db738c48777b696e374f8b428f0647debfb424f44d2f426370407fe2f"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
