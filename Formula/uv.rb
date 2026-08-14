class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.4/uv-aarch64-apple-darwin.tar.gz"
      sha256 "99a913b606194867b43086404412c1afe079547fee72ecfb6af7e7b0dd54b0c6"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.4/uv-x86_64-apple-darwin.tar.gz"
      sha256 "e603f1eb634ca97a2a125539b983891f53235e901511ed10c32c08c86e253ecd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.4/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "49d881b3403187e1f1789720881e77e4251ad4259d86c4844862657d2a35d13f"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.4/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c8c60f47e6f88d18dbf6f33d7279fb1fbf7ae76631768152cf5578c3d65729b4"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
