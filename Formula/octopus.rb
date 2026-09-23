class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.8/octopus-darwin-arm64.zip"
      sha256 "424349d59e69993b1b9611f11e962369e1905a93ad1f63c6d849a7307888e44b"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.8/octopus-darwin-amd64.zip"
      sha256 "fa0540794c2f29df25da1141697feb9ca69e570525dd911fbf2d3a01e2ced224"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.8/octopus-linux-arm64.zip"
      sha256 "43005de46a78db5eb4f7693090ea9a9abf6eb23af21baac3f3a0fe3f1ea18097"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.8/octopus-linux-amd64.zip"
      sha256 "5cbaafc035dbee86724df83e431d0f06c32180a80718d50d8bdaf964e7734a14"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
