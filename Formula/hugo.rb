class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.163.0"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.163.0/hugo_0.163.0_linux-arm64.tar.gz"
      sha256 "514475eac3bf401ac07f46c7f92b459412b82bd854f35f843553635d4e28958d"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.163.0/hugo_0.163.0_linux-amd64.tar.gz"
      sha256 "c5f3ef2e706d53216a5ffe07cf0ca5e402b3d2ab78adf3f06e6ce81b4f14d397"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
