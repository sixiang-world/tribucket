class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.3/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "136a4db6512d9b16dda56ac8604696ed65c3b1a914a142de029e7f8d5006f1d9"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.3/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "05c2a6705e7c0c056d6d93ff538978583f0c47b4c28d334ab9d58d2e8daf4c24"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.3/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b9cc833f5db856484b38718c9da195a6ec990707307bda30530913a09705419a"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.3/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7ab3b978d2c0b1c96b2323d4e5c4f35284ae1cdf35d2f7399595c74c805f5fa3"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
