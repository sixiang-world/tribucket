class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.2/octopus-darwin-arm64.zip"
      sha256 "bdf046d27371c5886f7f0018fdccdfd602cbf331311c6a4eb44ecff07ab07b44"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.2/octopus-linux-arm64.zip"
      sha256 "b2755f49d26187ca52fd62ba32bd259c11f456fec858baf6bc5b97f143f7fb3d"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
