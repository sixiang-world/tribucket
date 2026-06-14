class Navidrome < Formula
  desc "Your Personal Streaming Service"
  homepage "https://github.com/navidrome/navidrome"
  version "0.62.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.62.0/navidrome_0.62.0_darwin_arm64.tar.gz"
      sha256 "f2e244fd633222c81f5b921f3e028ff6c023833f9f7265740a7363c9074a9543"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.62.0/navidrome_0.62.0_darwin_amd64.tar.gz"
      sha256 "0f4286dc8836c4696335cc40fd4b10f7196f90170d527e81bf0745797126b842"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.62.0/navidrome_0.62.0_linux_arm64.tar.gz"
      sha256 "842ed7f70c0dcfd85ef08427241c1327b13af9d025b43d0cedcd8c7e2c6b35b5"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.62.0/navidrome_0.62.0_linux_amd64.tar.gz"
      sha256 "0e1044254cc1dd1a0b390da143fef95695c7eb738b1e7d2975adcec3cb78f152"
    end
  end

  def install
    bin.install Dir["navidrome*"].first => "navidrome"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/navidrome --version 2>&1", 1)
  end
end
