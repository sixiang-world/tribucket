class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.0.0/tribucket-darwin-arm64"
      sha256 "7f78e09755341025cf3a23afea6b606b6cc084bcbafa3d189e6a2e12c2a682ea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.0.0/tribucket-linux-arm64"
      sha256 "fd52181e5ac0af3ed2085d3999d1fc307296333ef9a994dbbcd5158928566492"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.0.0/tribucket-linux-amd64"
      sha256 "6b198862e5ad5ace5bb178b8dd61c0282b23ef4e6becc91e4104816ac7d77f65"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
