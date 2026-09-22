class Navidrome < Formula
  desc "Your Personal Streaming Service"
  homepage "https://github.com/navidrome/navidrome"
  version "0.64.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.1/navidrome_0.64.1_darwin_arm64.tar.gz"
      sha256 "1819a689bfce38c4ecf1ad2764f5f3d61b099c5d67dd99e83e3c1574889e0891"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.1/navidrome_0.64.1_darwin_amd64.tar.gz"
      sha256 "22ce967d4c1c0e929640082de52d375a48bdcf6d3a06436c48f9a2c0da9ab469"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.1/navidrome_0.64.1_linux_arm64.tar.gz"
      sha256 "a496bd0587f110db15ef5aa729365834f371a7e0be6bc2ff20ceefa2945358e9"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.1/navidrome_0.64.1_linux_amd64.tar.gz"
      sha256 "f070cda7b8e27d605fdc9a45a18d9a65cec7157f3b6d440c97dd25828eb5fc61"
    end
  end

  def install
    bin.install Dir["navidrome*"].first => "navidrome"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/navidrome --version 2>&1", 1)
  end
end
