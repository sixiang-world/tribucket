class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.6.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.5/tribucket-darwin-arm64"
      sha256 "14718406f53e1d1c984995d9880db280c954347c02ca9cd2d5f641e166f73133"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.5/tribucket-linux-arm64"
      sha256 "7c0b238041dd2aa8d7137bb77ddd31ebcad0a8ba11e993e27e1a49cb72ca3ce6"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.5/tribucket-linux-amd64"
      sha256 "71c302219cb5ddf84b42992741eb48277b5580d560418857ea830e125f4a712e"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
