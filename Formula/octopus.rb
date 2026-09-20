class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.6/octopus-darwin-arm64.zip"
      sha256 "7f094b4be0e82c33d2ad21e76aa1a54a20352d832b7db8855f2cebb43d365bb1"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.6/octopus-darwin-amd64.zip"
      sha256 "a9dd8df8ee92227441b05766a5c6fdf2a7f606c2f9ddf2291bcd11f19a1226cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.6/octopus-linux-arm64.zip"
      sha256 "bb25a6645a913a9d8267e8e6cc840cb574ffb02454ec4ebb574e016c858e5c0c"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.6/octopus-linux-amd64.zip"
      sha256 "0d86ed3239083281f8529183fc51304bb526d85d622d40484dbd3402942e42cb"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
