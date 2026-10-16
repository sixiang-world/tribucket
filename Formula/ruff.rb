class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.17.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.1/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "1c8e6e36538eaa0b996378a20c226403c4ca6369ac24884751b024d3a9530b86"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.1/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "88ee16f88dba9d440e06375f46898ec85baf578042ad086764d5a33558bb6e17"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.1/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d3ead1f0ed779e777a034ccd9286be6bd9bd3cdaba732ff9797f8288a283e9e2"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.1/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a293ac937715ae6fb6b64da86761598379e6149f40fbc00fde9ba8a2a562ac65"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
