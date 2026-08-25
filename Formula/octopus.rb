class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.12.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.12.1/octopus-darwin-arm64.zip"
      sha256 "1f56056d345a5c56b3851c9cca08e54708b137ea8e4ac676bc0a40dc7b52fb09"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.12.1/octopus-linux-arm64.zip"
      sha256 "2bb654589eac3ab589facff4ec838dc0e00d3406165a2ae47e0209628822a9dc"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
