class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.12/octopus-darwin-arm64.zip"
      sha256 "58ed2f97e73d1afe54aff1ff411bfff74c3822663ea7ff2706e9c5fefad23229"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.12/octopus-darwin-amd64.zip"
      sha256 "fc33c43a7f91b5f9595d56dbfdc0332747415302373b557f08e98fa3b657b340"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.12/octopus-linux-arm64.zip"
      sha256 "78fe5f77cd56f58e8a52e360b9cc8623b3e7eff525119a7213a7ddcc234dc2c4"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.12/octopus-linux-amd64.zip"
      sha256 "fb48a40a82ff46f7d0aa172384e2376d390a9b801f78c9dd196a832b4a899840"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
