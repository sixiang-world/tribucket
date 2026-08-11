class GoMusicfox < Formula
  desc "Terminal-based Netease Cloud Music client written in Go"
  homepage "https://github.com/go-musicfox/go-musicfox"
  version "5.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.1.0/go-musicfox_5.1.0_darwin_arm64.zip"
      sha256 "e51a5f90b398c77769747571cf9c860883e74d7e8af55bb1bbd82b45ac083257"
    end
    on_intel do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.1.0/go-musicfox_5.1.0_darwin_amd64.zip"
      sha256 "c46e96047f37f697a3f273d31f132d2a8171e26bdf9db1678710d571e56a1ec3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.1.0/go-musicfox_5.1.0_linux_arm64.apk"
      sha256 "1b134a375700e27d122928e057417e2f15f173b08309af6860b4b242d925aec7"
    end
    on_intel do
      url "https://github.com/go-musicfox/go-musicfox/releases/download/v5.1.0/go-musicfox_5.1.0_linux_amd64.apk"
      sha256 "69d504cf4ab37d5a1dd9b8bdf56b55c959b5a2026577341f002e94fdb817fbab"
    end
  end

  def install
    bin.install Dir["go-musicfox*"].first => "go-musicfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-musicfox --version 2>&1", 1)
  end
end
