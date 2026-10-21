class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.102.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.102.1/gh_2.102.1_macOS_arm64.zip"
      sha256 "08bfef98b50c553df122bb34ee8dcf415cae7d3b108891488964a0df07aa2aeb"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.102.1/gh_2.102.1_macOS_amd64.zip"
      sha256 "91c5fbd493274b545b03ef32a89c2a21238393c0c0b1108210967199b3230d9d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.102.1/gh_2.102.1_linux_arm64.tar.gz"
      sha256 "5019b3cc6e8a03bb4d88600f8dbda2add8e6407705c159b0c63151036e77a1af"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.102.1/gh_2.102.1_linux_amd64.tar.gz"
      sha256 "77b9e297e94c50336823d0f84de7ef1be60cba704601fa0d98f129f47a94987b"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
