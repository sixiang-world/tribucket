class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.169.0"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.169.0/hugo_0.169.0_linux-arm64.tar.gz"
      sha256 "ddadaaccbf437e3d39c33140b80c2180c4f46d027d16b7716c1282ea2e14e00c"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.169.0/hugo_0.169.0_linux-amd64.tar.gz"
      sha256 "2d2f0bfe357d8cb4cec02f6bb28a3bff34978c8dda44b618029c5eb9d66765a7"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
