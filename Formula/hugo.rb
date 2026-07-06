class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.164.0"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.164.0/hugo_0.164.0_linux-arm64.tar.gz"
      sha256 "948ee5f0ed30175f31937d592d63a2712f0761a69f1cbe812f780eb918a08b8e"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.164.0/hugo_0.164.0_linux-amd64.tar.gz"
      sha256 "d9c8b17285ea4ec004d9f814273ea910f2051ce02c284993fd1f91ba455ae50d"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
