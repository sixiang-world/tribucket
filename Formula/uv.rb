class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.30"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.30/uv-aarch64-apple-darwin.tar.gz"
      sha256 "9bed3567d496d8dab84ecf7a1247551ac94ef1baaebb7b65df008dd93e9dc357"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.30/uv-x86_64-apple-darwin.tar.gz"
      sha256 "ce285fbbfbe294b1e1bc6c87c8b59d9622b85383b88b2b132a2df5c73e83d7c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.30/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8c11d90f5f66d232930cf8ae3a085c39877690d409e10878234802b028b20e2a"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.30/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "04bc7d180d6138bf6dc08387acf507a823f397a98fea55da36b0ccc7fbce3b68"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
