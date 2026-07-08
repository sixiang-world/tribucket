class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.28"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.28/uv-aarch64-apple-darwin.tar.gz"
      sha256 "33540eb7c883ab857eff79bd5ac2aa31fe27b595abecb4a9c003a2c998447232"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.28/uv-x86_64-apple-darwin.tar.gz"
      sha256 "2ad79983127ffca7d77b77ce6a24278d7e4f7b817a1acf72fea5f8124b4aac5e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.28/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "03e9fe0a81b0718d0bc84625de3885df6cc3f89a8b6af6121d6b9f6113fb6533"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.28/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e490a6464492183c5d4534a5527fb4440f7f2bb2f228162ad7e4afe076dc0224"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
