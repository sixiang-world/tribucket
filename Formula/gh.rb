class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.93.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.93.0/gh_2.93.0_macOS_arm64.zip"
      sha256 "a86be4e0a86c26456cf71177d6572d6f1165cf1679e532b72f7f15918ee51fd2"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.93.0/gh_2.93.0_macOS_amd64.zip"
      sha256 "009425b9d175c482037fe25181817fd6b1ea3ae1f51cfae0e18f29f33d3152ac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.93.0/gh_2.93.0_linux_arm64.tar.gz"
      sha256 "c55feb33684abba57e9909737340d5b39282257c0363e1edde6785ac4a413be7"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.93.0/gh_2.93.0_linux_amd64.tar.gz"
      sha256 "02d1290eba130e0b896f3709ffff22e1c75a51475ddb70476a85abc6b5807af0"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
