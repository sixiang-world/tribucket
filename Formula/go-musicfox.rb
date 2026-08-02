class GoMusicfox < Formula
  desc "Terminal-based Netease Cloud Music client written in Go"
  homepage "https://github.com/go-musicfox/go-musicfox"
  version "5.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.1/go-musicfox_5.0.1_darwin_arm64.zip"
      sha256 "0dbb76f805984c609d0db47a8eb68d9cca9a87165971caa32c7468ce1b6cfaf7"
    end
    on_intel do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.1/go-musicfox_5.0.1_darwin_amd64.zip"
      sha256 "57c93f315709282ed197881c5d485cba252005aaf69645ff52fb90d6e750acf8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.1/go-musicfox_5.0.1_linux_arm64.apk"
      sha256 "f09e3f5bdf7e039e0e0dd49f971412ff90dd8a007d3f4c2d54db301d0208de3b"
    end
    on_intel do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.1/go-musicfox_5.0.1_linux_amd64.apk"
      sha256 "662ec6e6916fc56f5ea6b14bed8311b8c9982b5ae5cd453a10722776eaaaccdc"
    end
  end

  def install
    bin.install Dir["go-musicfox*"].first => "go-musicfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-musicfox --version 2>&1", 1)
  end
end
