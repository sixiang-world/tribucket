class Hugo < Formula
  desc "The world's fastest framework for building websites"
  homepage "https://github.com/gohugoio/hugo"
  version "0.163.1"
  license "Apache-2.0"

  on_linux do
    on_arm do
      url "https://github.com/gohugoio/hugo/releases/download/v0.163.1/hugo_0.163.1_linux-arm64.tar.gz"
      sha256 "8e6a6f5cee73670c9a423029d6737e88bdfb4d80b090b925d35720fb69629b19"
    end
    on_intel do
      url "https://github.com/gohugoio/hugo/releases/download/v0.163.1/hugo_0.163.1_linux-amd64.tar.gz"
      sha256 "13d9ba5c3b2fca17a630f0251a8f41e97875a23a4b85b14ae8991d4282dae53f"
    end
  end

  def install
    bin.install Dir["hugo*"].first => "hugo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hugo --version 2>&1", 1)
  end
end
