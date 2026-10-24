class Gh < Formula
  desc "GitHub CLI — GitHub from the command line"
  homepage "https://github.com/cli/cli"
  version "2.103.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.103.2/gh_2.103.2_macOS_arm64.zip"
      sha256 "5416000f5d17580a187339e0c4068a01ca5c87f7d4fe6ca64933696f967bc418"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.103.2/gh_2.103.2_macOS_amd64.zip"
      sha256 "2dc7f1fc4761f96732995f6e4f4c6b4d705f2635da4126620c8b30eaa67b9c98"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cli/cli/releases/download/v2.103.2/gh_2.103.2_linux_arm64.tar.gz"
      sha256 "4c3e99a50bd8b181a3fe9d69b25dd978bac768148d88f01507c6b4d1ef61a443"
    end
    on_intel do
      url "https://github.com/cli/cli/releases/download/v2.103.2/gh_2.103.2_linux_amd64.tar.gz"
      sha256 "62ccf747115ddc61237efffdde66a3c8f70ba249433dc64f70801089b59c59c8"
    end
  end

  def install
    bin.install Dir["gh*"].first => "gh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh --version 2>&1", 1)
  end
end
