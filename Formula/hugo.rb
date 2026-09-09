class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.166.0"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.166.0/hugo_0.166.0_linux-arm64.tar.gz"
      sha256 "0e15cbc595e799401698c11af39d2594b64292b39d9ec7a19665bd43e05fcb2c"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.166.0/hugo_0.166.0_linux-amd64.tar.gz"
      sha256 "45228f5a52eb118b0ca168068f01d7df0447314a24056f1d29667ed9fc368308"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
