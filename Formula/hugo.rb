class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.163.2"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.163.2/hugo_0.163.2_linux-arm64.tar.gz"
      sha256 "27ae0752214186483b215660ea6877ca5dc674361b582be03f2ae0e16efad5cd"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.163.2/hugo_0.163.2_linux-amd64.tar.gz"
      sha256 "eae3a1b94930de1f1dcb89fd5e885c33bba7fda1bae93412999956c945f9d5b0"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
