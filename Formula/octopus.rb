class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.11.0/octopus-darwin-arm64.zip"
      sha256 "6bf849acad70749b84eac728355c9d470d9fd2fdf23f6cfc0d96546a2cf34b48"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.11.0/octopus-linux-arm64.zip"
      sha256 "25f9c4a83ad8ec7d2209c9a0c499b39fad0aad5a4753855d2a788baa611fb4e2"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
