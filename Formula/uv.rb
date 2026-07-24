class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.32"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.32/uv-aarch64-apple-darwin.tar.gz"
      sha256 "ed336d0ba49db8ef89b2b41fffa372ce63bd032f22a56f001c265891aec32829"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.32/uv-x86_64-apple-darwin.tar.gz"
      sha256 "77f5ca26c0de20e992a3677a174fe1121ee25c36f9b1434a863f75bf077a05eb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.32/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4d4fa08d95b06642e5800df6a22bd71455f23f988269e18da2847971d8c0bf31"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.32/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aab924fd522efd06f1c5f3b93a243864fc453132c94b2dc49f1371b528a4b967"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
