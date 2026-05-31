class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.162.1"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.162.1/hugo_0.162.1_linux-arm64.tar.gz"
      sha256 "ed2a4dcdc4149b575693b35d0f7220fe5248b70179097bed4cdbf98a238cbdca"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.162.1/hugo_0.162.1_linux-amd64.tar.gz"
      sha256 "4bfcdb092d0306586f1b72e5687787ead053faab2d71f09951d3c5fecde66873"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
