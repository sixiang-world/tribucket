class Navidrome < Formula
  desc "Your Personal Streaming Service"
  homepage "https://github.com/navidrome/navidrome"
  version "0.63.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.0/navidrome_0.63.0_darwin_arm64.tar.gz"
      sha256 "1365a67d923e2522db689a8d73e3c773fe31161802edbf1ed9e0463613faacbc"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.0/navidrome_0.63.0_darwin_amd64.tar.gz"
      sha256 "a14395f4b4578c1c469de0d564a4256be898c6b062b4747af5e913dec0f60958"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.0/navidrome_0.63.0_linux_arm64.tar.gz"
      sha256 "4133b410dc117bbe965c3dddc9fff6fca5dec5c400a9f66d7be99e612869fe2a"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.63.0/navidrome_0.63.0_linux_amd64.tar.gz"
      sha256 "fe4d745e372825efa584e363ac6d9e424337b54f919bdac6f424515030db0613"
    end
  end

  def install
    bin.install Dir["navidrome*"].first => "navidrome"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/navidrome --version 2>&1", 1)
  end
end
