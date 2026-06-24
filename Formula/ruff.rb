class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.15.19"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.19/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "c7253342f2ffbe2a0eaadaacd3424c3a24331b0307e57cc54031bc7ccd35d83a"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.19/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "aaf50afd2a76be2674b8dd24b305e42a33a99269c2c43e334f6a940b29ca291c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.19/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b00f8c17424c0abea8f87ca52880b864d10ae8e5c5d09ee61730a80ee3874a97"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.19/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0bfabff71f317e0e3b8c363043b888f045eff092073d5d9bd0ac7f8ede465711"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
