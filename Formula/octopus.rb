class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.1/octopus-darwin-arm64.zip"
      sha256 "3a3d78cc6ed6d838fb387c284b3703fdd8aa7671b9bfc97fe75361410279c9da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.1/octopus-linux-arm64.zip"
      sha256 "23ad0345f5cd501a6cfa7fb8871e9a08bb6f18f3efa0ce0b72f90d59d0a870ff"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
