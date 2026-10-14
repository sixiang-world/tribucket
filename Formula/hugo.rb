class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.168.0"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.168.0/hugo_0.168.0_linux-arm64.tar.gz"
      sha256 "91ce984e998a955a3dc1b5852eb4e65d0ed0f6d12a5c51690df97a548e1fdeeb"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.168.0/hugo_0.168.0_linux-amd64.tar.gz"
      sha256 "fada83ad56bb27ed4cb7dd81590303bdac16140f944ac4e66fc248117e2d5594"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
