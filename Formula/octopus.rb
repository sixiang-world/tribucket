class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.12.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.12.0/octopus-darwin-arm64.zip"
      sha256 "d20fa606882fb0a80a65188c1d91d8fad6af9fbb4ca707e944ae87560613d157"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.12.0/octopus-linux-arm64.zip"
      sha256 "66375a5a457fb40fc4128bde0954b1043f22ecb3a53098a86488ca8e56246ed6"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
