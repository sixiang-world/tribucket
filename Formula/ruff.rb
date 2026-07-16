class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.15.22"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.22/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "a2881af26fd1d19f4932c4ddf1e70b4e0efcf48513c5dae082564e03f0b467a3"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.22/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "687a9ceb88ab85dab061026d5017218225a481121b1a40862cc8f92b56f18090"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.22/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "54ec426d839d7cea1096e9ea1c5486fd2f3df62ee6cfd71dc090b18f99bebd90"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.22/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d535a4be6504146e757eff67b992f11a293a7a108be22e2a5898b32c32565996"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
