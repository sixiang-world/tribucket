class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.0/octopus-darwin-arm64.zip"
      sha256 "066203f5dd50692fe4ea7944b6dd01460e1a1f7d0d27e7214060dcb018dbdef6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.0/octopus-linux-arm64.zip"
      sha256 "fb2e7326c9275e58a4af41a24fe3ac582c0c90937ab128f73fb1e956c59de727"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
