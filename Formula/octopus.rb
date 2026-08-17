class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.10.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.10.1/octopus-darwin-arm64.zip"
      sha256 "59e09e80192ceb9a009e24b4987f6f78605cf63e798663f40d6461c4483898c9"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.10.1/octopus-darwin-x86_64.zip"
      sha256 "6bfb6c861f092710749dfa068319c19e3a99c8e0083dbc7607eeb6c683e37876"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.10.1/octopus-linux-arm64.zip"
      sha256 "5f620388a650732149e61cb0f65ed3d895afd6a6c352eb554ddb8df2f3ed4656"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.10.1/octopus-linux-x86_64.zip"
      sha256 "9b183e08693e2129a0a9064f06e2837cadc6ff0c9b0340d2bafe942dbfde6d4b"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
