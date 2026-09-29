class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.21"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.21/uv-aarch64-apple-darwin.tar.gz"
      sha256 "b88bda573e566ef9bced66b155fe0408626fbbc053aee1c30ba686f0728c9447"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.21/uv-x86_64-apple-darwin.tar.gz"
      sha256 "2b336763b396ec6afa20c5a8b083538ca7402445b868311979d740a4344c17d8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.21/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "030b69227b40af8c1981b7301793dc66e71ed3c796ea8688209dd268bd91ec51"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.21/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23f02075b652bb1df64178cfae41b5caf160822e720e2663568f3f5d63bc52c0"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
