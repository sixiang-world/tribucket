class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.17.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.3/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "118f7121aa838785672bf612487f755a89108bb5f44e0f3df96c5967a72614f9"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.3/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "17f95b1bee24d70de62ffe5beec7f71bb541c7e3d147a1c3d84f7cd6525f6fdf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.3/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3f4639152c0e42bb5938e6c23d53d527a38f3133e000102934518f90529fa299"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.3/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2b0890f5a55900af741f133918c2656919bbf18c2ab7741b4ca8403a90e647a9"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
