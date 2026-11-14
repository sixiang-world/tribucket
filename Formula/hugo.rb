class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.170.0"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.170.0/hugo_0.170.0_linux-arm64.tar.gz"
      sha256 "4ec3acd12ac17dbffb34fa453d3630dc0926a2314c8cd4964a550cfa9a4dbc73"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.170.0/hugo_0.170.0_linux-amd64.tar.gz"
      sha256 "0930754ec22ad2dd1a252f8c31a5e57faccc9d15f1c3d381ddafcb96eeb8aef0"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
