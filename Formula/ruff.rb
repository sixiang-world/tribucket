class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.17.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.2/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "94fbca85f19e8b6bb068adb7cbc9a74e3e6c01004cc67c6b00246a094ad4ccd9"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.2/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "db57a84e385435a2c4a7c8946e588f79b9de0851d8618a1b5d4431edfff0bf01"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.2/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "468f29d64949574f0d28442c02f0b4fb680cff7ba8fc26b6287a73b945308e1c"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.2/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7b2e6a6e132ecf7b5fe726163b186d5d209befe93bb25f83767b2d97fbdf14e5"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
