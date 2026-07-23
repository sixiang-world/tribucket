class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.0/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "ce6564491a2cc4b0659f45ee174dbef17e4dec24e03a9c03d313b5430bc21099"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.0/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "3d9ef6228c4eeb26d593c398b2dc5250e0f6d6425933db2993fcf30d49c78b69"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.0/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "879d4f0ca1a7f21a4afc6ef9345118b8a75aa2bc4aae9e41e0474994d0ef0a4f"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.0/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "98001c995a134d95f9bc83106a7f94b552971b583f1c0ab75fb656a881e13865"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
