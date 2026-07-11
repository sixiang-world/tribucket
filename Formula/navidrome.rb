class Navidrome < Formula
  desc "Your Personal Streaming Service"
  homepage "https://github.com/navidrome/navidrome"
  version "0.63.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.2/navidrome_0.63.2_darwin_arm64.tar.gz"
      sha256 "f621f1b730af93d200d3400e549f60b34dd796d27801ebf9b6ab219df6ac7048"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.2/navidrome_0.63.2_darwin_amd64.tar.gz"
      sha256 "3dbcfc81217b5f8451aea74c7456a4431983e8aad39aa66c0fec03f7796c45da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.2/navidrome_0.63.2_linux_arm64.tar.gz"
      sha256 "5b74fb0eea5d48e3eb7565ea4116284232509e94431cb3756aaac2128dd50a43"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.2/navidrome_0.63.2_linux_amd64.tar.gz"
      sha256 "224c6d6fe5cc11a9c9387b97988666423de38bb5ef2e2f43ecc43d0a3dded4f0"
    end
  end

  def install
    bin.install Dir["navidrome*"].first => "navidrome"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/navidrome --version 2>&1", 1)
  end
end
