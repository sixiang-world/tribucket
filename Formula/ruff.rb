class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.8/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "0ffa53899f2970d24f14fbed8d8265c87180b159b7100794d97a1527dc60fa79"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.8/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "bccb4d49c5c9f7e69fd42df2475730a08a641af31b8e0ee5e775e3dd829c4686"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.8/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8ff18ee07d6ed3cfbd05fdc9012646a79482c00045dbcbf32416ef8f14ab1f7e"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.8/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c4a8c7c152532bcb7e7ede4bd6ccd440dcacddffcdcdd79b90090ac6021f41c2"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
