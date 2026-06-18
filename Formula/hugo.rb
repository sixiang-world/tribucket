class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.163.3"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.163.3/hugo_0.163.3_linux-arm64.tar.gz"
      sha256 "a4185cf0308ff3a61a2828563f70f476fcef30d02e9b00fb562eb1bd085195a5"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.163.3/hugo_0.163.3_linux-amd64.tar.gz"
      sha256 "ec422258f9a4ffc241de8707297e32311cd86fcc9b2813632617ff4d44935d91"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
