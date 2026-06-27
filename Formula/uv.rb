class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.25"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.25/uv-aarch64-apple-darwin.tar.gz"
      sha256 "5fc334bb25d19806262efd1f6e7d380155c7e817d89bf426df4ba7ae873c9471"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.25/uv-x86_64-apple-darwin.tar.gz"
      sha256 "65ff85b33212f75d34d7c0f0724aba9a742c74f62559f67dc0d6c543dc2fc52f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.25/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e0e9d73f74e06a7dcd53910d5962146ab48f0af9c92cc8df33a37baa0121014d"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.25/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1db18b5e76fa645a7f3865773139bdec8e2d46adbdbb35e7410b34fa8015ccd2"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
