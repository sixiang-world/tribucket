class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.10"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.10/uv-aarch64-apple-darwin.tar.gz"
      sha256 "51c6170e8e3a01cef9f33b94f582b7b81ac65046f55d40afb35f9cff5a68c179"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.10/uv-x86_64-apple-darwin.tar.gz"
      sha256 "5296d5aa2b9143360405eea866f8ef4d5dc8986b164eb0dc35e8f876a9304d30"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.10/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9ff6b9d4665edcdd3a88dcc73cd1eb641754deb927f14e8c62ebfde6bf4f5f5e"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.10/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "173d95a0c32d18c896c46ba6fafbf3cf9c14ab74b033f81b76c883ef492a976b"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
