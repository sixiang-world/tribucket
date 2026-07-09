class Navidrome < Formula
  desc "Your Personal Streaming Service"
  homepage "https://github.com/navidrome/navidrome"
  version "0.63.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.1/navidrome_0.63.1_darwin_arm64.tar.gz"
      sha256 "c0abb41b41dc92677152ff79077117ef2a8f8c96358715da363a269bde57664a"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.1/navidrome_0.63.1_darwin_amd64.tar.gz"
      sha256 "bbc1edf7e225d64626976fb22ed96feb103498f587f9571b35876bf786697ec7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.1/navidrome_0.63.1_linux_arm64.tar.gz"
      sha256 "c1b1293362ef9040de43367a4e453fe490d442bf73c05df45f5bd73d8d4eb337"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.1/navidrome_0.63.1_linux_amd64.tar.gz"
      sha256 "5e388bfaeebf2d096cf682704f295043d2699896a9e542d7c7d32cdaa7a03d8d"
    end
  end

  def install
    bin.install Dir["navidrome*"].first => "navidrome"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/navidrome --version 2>&1", 1)
  end
end
