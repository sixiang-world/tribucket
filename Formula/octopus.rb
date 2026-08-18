class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.10.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.10.3/octopus-darwin-arm64.zip"
      sha256 "86960148276c34d3768fef2f81d6722aede3dc2c5625a23220663957e7294900"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.10.3/octopus-linux-arm64.zip"
      sha256 "e4dbc807a0203b32d2170c90a8c9f1ff4d17f91fe561d5a859fb4c3126f19762"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
