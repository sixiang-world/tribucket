class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.13/octopus-darwin-arm64.zip"
      sha256 "56217f15e7ef071ef53cb28c7cf52c05a3d4f918811116f758d90bffe95a5090"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.13/octopus-darwin-amd64.zip"
      sha256 "6ae44624f7f016946521d27751c2bbae34c466e33351e7b7cb7933fc48f3d8fb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.13/octopus-linux-arm64.zip"
      sha256 "59b3c64a48efe725a3db2cc7ce25a5194297afa8a5311bb9e7efd5fdd763d5c7"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.13/octopus-linux-amd64.zip"
      sha256 "24ccfddfbe7710e8e045d57042d3d3f76a83a313a4c4cb3964fa72786766607f"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
