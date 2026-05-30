class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.162.1"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.162.1/hugo_extended_0.162.1_linux-arm64.tar.gz"
      sha256 "f5531494dd573cfc142779894a9e3e414ab05626d6e0492cc06209dc783aaf39"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.162.1/hugo_extended_0.162.1_linux-amd64.tar.gz"
      sha256 "e34160095b6a6406af857fe212f50e4451f67ed1276b9bb0de13d08754980118"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
