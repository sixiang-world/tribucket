class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.14"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.14/uv-aarch64-apple-darwin.tar.gz"
      sha256 "dfed5683c5873d65eff8476eb93526059b81e5646a68305b5c94a26b29990894"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.14/uv-x86_64-apple-darwin.tar.gz"
      sha256 "e11a70264ceca38e929ecaeed953c323e517af7b960ebf9722d5918e8c7f0375"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.14/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7fb91bd5d10529c60723eaec3caf44726f89280e5aeed78af8fc63fcad004c9b"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.14/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "18ef5c3888ae59828cb13f38d57e9389b8173ecc719eff163bfafc74b38f5936"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
