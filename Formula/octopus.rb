class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.4/octopus-darwin-arm64.zip"
      sha256 "fc1507fcea4118b89545c9b1a560f5287ac696b7141b26ec6a04ed900c01a98b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.4/octopus-linux-arm64.zip"
      sha256 "a1c656123f27104747c28ebc7d35f7a707c46c8b1ee87e0d3c7cd545f2f15f93"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
