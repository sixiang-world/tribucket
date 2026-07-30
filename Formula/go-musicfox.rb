class GoMusicfox < Formula
  desc "Terminal-based Netease Cloud Music client written in Go"
  homepage "https://github.com/go-musicfox/go-musicfox"
  version "5.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.0/go-musicfox_5.0.0_darwin_arm64.zip"
      sha256 "c71d12385a6342c01409efc53590058e327f795889529b13adb7a60aa27b760f"
    end
    on_intel do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.0/go-musicfox_5.0.0_darwin_amd64.zip"
      sha256 "fb115df73f13ab151d82635e27c34951f3094535ea9ad04ddc4ef9b21b8df423"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.0/go-musicfox_5.0.0_linux_arm64.apk"
      sha256 "3d66f5cf6b93e3e3ba07218f9ef84243caac79aa9af87df8efcc379ddde24bd1"
    end
    on_intel do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.0.0/go-musicfox_5.0.0_linux_amd64.apk"
      sha256 "f15c16a8a7d48f706ec5932146b7cd5a95231a5eb9af2273ca99715baa7bd7c3"
    end
  end

  def install
    bin.install Dir["go-musicfox*"].first => "go-musicfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-musicfox --version 2>&1", 1)
  end
end
