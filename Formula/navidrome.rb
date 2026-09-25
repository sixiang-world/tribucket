class Navidrome < Formula
  desc "Your Personal Streaming Service"
  homepage "https://github.com/navidrome/navidrome"
  version "0.64.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.2/navidrome_0.64.2_darwin_arm64.tar.gz"
      sha256 "8b0a7798001453719ad50c12f7025a6044546c4a3568efe51feb296681f29956"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.2/navidrome_0.64.2_darwin_amd64.tar.gz"
      sha256 "bc872847dcd1c0d760bb9b8730f2a3c876e0ff0679e5440755c37697f2804a23"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.2/navidrome_0.64.2_linux_arm64.tar.gz"
      sha256 "6d1683428cb6d99cdabc3da815b94cc161de5904820130c5b9e2e42c34dcdb15"
    end
    on_intel do
      url "https://github.com/navidrome/navidrome/releases/download/v0.64.2/navidrome_0.64.2_linux_amd64.tar.gz"
      sha256 "fdd87fd107818667c2c50bc24dc6ce856962c795b3822a91f95c066cfad2c53e"
    end
  end

  def install
    bin.install Dir["navidrome*"].first => "navidrome"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/navidrome --version 2>&1", 1)
  end
end
