class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.9/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "33d35394499094cf6eb90f730dc82f11c0fab05d176378ae4f67de985ecc4146"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.9/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "e98ea259a021c87d3a1f8bf18639d2e32dcd45cb2ef1afcb41b13e295de1e2b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.9/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a13061e8f471b49c9d2aa284c32dd54a0e5534d702d1a44e1d7f4c875569586d"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.9/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1bfbb819b5d4f9af501748862276b60e412d336034d99387691a4d4bce7a6f13"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
