class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.93.0"
  license "MIT"

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
