class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.167.0"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.167.0/hugo_0.167.0_linux-arm64.tar.gz"
      sha256 "d0dd0d1ed249842525a93413e10ca1ef6f3b63311ee1695b16a0ce488142cec1"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.167.0/hugo_0.167.0_linux-amd64.tar.gz"
      sha256 "4d84519b9f619e6d4c3fb45a50157abeabeb724f859c60605f44c23def6e1169"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
