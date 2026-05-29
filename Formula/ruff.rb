class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.15.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.15/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "2f7063e09d3c2af019b56f4fc6548199851e9387f359d696111af312adfe7619"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.15/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "e43d7c03701c7a436e18da455baf29e4be3379fb70887c4dc65091dfa73c1747"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.15/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d334ae13383977fdaf754e6ea3d85c7b3ccbd510c713463eca73d0cd7151fe12"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.15/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2c50f95a0f553731c87f8dc413465aa06059a0dc21dfe16786682db95ffeb9dc"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
