class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.15.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.18/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "f0cc66c2df37f2a11c99a85b59b8fde21b37f61df062404a0afaed387b56dad0"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.18/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "229d2c192718fde76794185ab9339515b75a55cc1337e4ca9d60309e2c506900"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.18/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c9636879455e940fc92edb95dd6e475d683da833987d1f0c147f39e521ae98a2"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.18/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1ffb1d5e04e60347be17c514cbb19303d6d8c75f629060ed481a150337dbf060"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
