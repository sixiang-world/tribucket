class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.13.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.13.4/uv-aarch64-apple-darwin.tar.gz"
      sha256 "e0b1d4743ce64c55d9f0f4a444afa6b81125680070ee04e853fcd0f6c1ebf8f1"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.13.4/uv-x86_64-apple-darwin.tar.gz"
      sha256 "7be2dcd316122f4b3e5a0a7889f6248266c14425374e105ff7dc9779184603a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.13.4/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1ae72b4718729e2ccc4f1ae2c6d1e531ca8467800e0546e9130b3886023a60ab"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.13.4/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2b428396f12572d4429cf210ca234dd599a33b3af0958a4d5ed569d63e3f344f"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
