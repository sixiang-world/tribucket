class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.170.1"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.170.1/hugo_0.170.1_linux-arm64.tar.gz"
      sha256 "6f57f13bc47c000c0d36c7f5a446d6c06f7956d8e102cc2a13735e0c0225b2d2"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.170.1/hugo_0.170.1_linux-amd64.tar.gz"
      sha256 "841a5462853aefc9942e4de1e8a5d75584b6a5181941e6ad3f1d745190e03cd8"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
