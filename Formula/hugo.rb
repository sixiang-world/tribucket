class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.165.0"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.165.0/hugo_0.165.0_linux-arm64.tar.gz"
      sha256 "65c9fdd75e82d5f1eaf565f6e9fede6c0ceecaa267798e10c73068986996b77d"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.165.0/hugo_0.165.0_linux-amd64.tar.gz"
      sha256 "5c3a37a5450b3e386e5b75a87a790fea2d04a796d75e171216c80ef48a32b432"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
