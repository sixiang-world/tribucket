class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.13.20"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.20/sing-box-1.13.20-darwin-arm64.tar.gz"
      sha256 "a5814443f27f14a95ac213d44cc7881540e5d49fa0994981f44a892563346a34"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.20/sing-box-1.13.20-darwin-amd64.tar.gz"
      sha256 "e2a11f43dc32768e089c55cc7184c59d9b4a5ecd0c689c9f79b9611530f2d3a9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.20/sing-box-1.13.20-linux-arm64.tar.gz"
      sha256 "7f8187b1d1d30258cd4fa70892eaa232649f8f28b294078eeac719579e14cf42"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.20/sing-box-1.13.20-linux-amd64.tar.gz"
      sha256 "646bc01bf128c32a12eb50d8690e387bba7504da7b1d65c704bd53916e38595a"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
