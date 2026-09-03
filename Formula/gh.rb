class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.100.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.100.0/gh_2.100.0_macOS_arm64.zip"
      sha256 "45f9a62da2f6e641a7fad57e2ce39656dfd7ef331372d80a2a2aed65abb01642"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.100.0/gh_2.100.0_macOS_amd64.zip"
      sha256 "fcd7799e85eb575f3c7d2b1679bfbfedaefa1269d4bc7d096b51e10939b4812b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.100.0/gh_2.100.0_linux_arm64.tar.gz"
      sha256 "ea4e7a581a32ccad6cc7923cb1576ac5859ba4b9a16ab22eb8f8a96e78e2e961"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.100.0/gh_2.100.0_linux_amd64.tar.gz"
      sha256 "e4d4bb4498e8d007abe545b6568926793ace1b6447da598294a610018cb164be"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
