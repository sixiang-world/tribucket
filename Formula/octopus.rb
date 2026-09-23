class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.7/octopus-darwin-arm64.zip"
      sha256 "a2c483ae7076001aa22ff69f91fb7fe3d33989f1539cf94a37ba612354e0fa22"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.7/octopus-darwin-amd64.zip"
      sha256 "3a3bfd460996feaedf986db04be0801959767add40b3f83fb4ff0a36d88e4c47"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.7/octopus-linux-arm64.zip"
      sha256 "286482bb31e027af0061ceca9b8b7cd1923db25dd74dfeca34d77672c6663f3b"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.7/octopus-linux-amd64.zip"
      sha256 "52d2010accd7fc17b0c499812f2792fd164287969554ea15bd6a791c294497ba"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
