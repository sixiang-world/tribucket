class Navidrome < Formula
  desc "Your Personal Streaming Service"
  homepage "https://github.com/navidrome/navidrome"
  version "0.61.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.61.2/navidrome_0.61.2_darwin_arm64.tar.gz"
      sha256 "d0a5b84718f93ce3c99d40f977dbeab200e2ae4188d31c10c9d231e78f775064"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.61.2/navidrome_0.61.2_darwin_amd64.tar.gz"
      sha256 "e103b4a182ac1d122f030b1cfa5c821c91dc05182047e044dadb12a85d8a9a69"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.61.2/navidrome_0.61.2_linux_arm64.tar.gz"
      sha256 "c8ee71c9072cb092a37a270a63916cef33fb4a90beaa962677e687223eee0c96"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.61.2/navidrome_0.61.2_linux_amd64.tar.gz"
      sha256 "66c8a91e09b5519140b7d2ae8638de9d69608237f186d9c96c959fbbe35dec79"
    end
  end

  def install
    bin.install Dir["navidrome*"].first => "navidrome"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/navidrome --version 2>&1", 1)
  end
end
