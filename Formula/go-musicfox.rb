class GoMusicfox < Formula
  desc "Terminal-based Netease Cloud Music client written in Go"
  homepage "https://github.com/go-musicfox/go-musicfox"
  version "4.8.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v4.8.5/go-musicfox_4.8.5_darwin_arm64.zip"
      sha256 "a7c1e3dc9632201dd93f86cfde377153993c27a73341ba032e2d57eb35df747e"
    end
    on_intel do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v4.8.5/go-musicfox_4.8.5_darwin_amd64.zip"
      sha256 "740f5ae301b36b8993ce28ad003894a150671ab146d3d05b93a8ab5c7b753658"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v4.8.5/go-musicfox_4.8.5_linux_arm64.apk"
      sha256 "9b4e9581835bea84915cef23f099c09b3941afb6abe30dc29a12bcc80b29cbd8"
    end
    on_intel do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v4.8.5/go-musicfox_4.8.5_linux_amd64.apk"
      sha256 "91486582ddc249c7a391eb70d370cc31c2fa9971b952d6834867ff317d2bdc0e"
    end
  end

  def install
    bin.install Dir["go-musicfox*"].first => "go-musicfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-musicfox --version 2>&1", 1)
  end
end
