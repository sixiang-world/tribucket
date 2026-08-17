class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.10.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.10.2/octopus-darwin-arm64.zip"
      sha256 "8b81738fc601eb3916c81ec83197ad56d444974b3a4d6d32d59d120a351bb4ab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.10.2/octopus-linux-arm64.zip"
      sha256 "7ac337bb21150e9c95c0871e00afe9602136834080b9e4c202e68ee4ed97d329"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
