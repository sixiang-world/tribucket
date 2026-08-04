class GoMusicfox < Formula
  desc "Terminal-based Netease Cloud Music client written in Go"
  homepage "https://github.com/go-musicfox/go-musicfox"
  version "5.0.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.2/go-musicfox_5.0.2_darwin_arm64.zip"
      sha256 "dfade2122f0601c68c7dd1807538b7f0245ff8d3cb813b1b3e9b1e67385552b1"
    end
    on_intel do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.2/go-musicfox_5.0.2_darwin_amd64.zip"
      sha256 "64725f369b71a9bf23030fddda0a7cfe0872a43f2621a38cb6fdadb666c38c75"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.2/go-musicfox_5.0.2_linux_arm64.apk"
      sha256 "59b729c2975a8510dfbd81c9a06ce8934f5d529571d596eb2bbcf86e7e55a3b0"
    end
    on_intel do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.2/go-musicfox_5.0.2_linux_amd64.apk"
      sha256 "6775d96f23283c4d09fd696c32183c3371701fac18cfe7221093492eef4217e1"
    end
  end

  def install
    bin.install Dir["go-musicfox*"].first => "go-musicfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-musicfox --version 2>&1", 1)
  end
end
