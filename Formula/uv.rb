class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.20"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.20/uv-aarch64-apple-darwin.tar.gz"
      sha256 "848fdeb602ff1a1baacd4f6c8b7bdc6cf1ad026a6d9cf59475fda17c179743ca"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.20/uv-x86_64-apple-darwin.tar.gz"
      sha256 "ac54283d211fd77cdc152b67606dbaf6406ff4ab03f3af4ae99468fa8e887141"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.20/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8a7aad7bc76a2fae5151566ff3e43eacce0b2a113d5e4de3e4afe3e58fa2441e"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.20/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6590717592ace991ff83a63fef799e3ad9d33ecc8f96c5d6bdd732496e79337f"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
