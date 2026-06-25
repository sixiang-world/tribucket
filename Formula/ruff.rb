class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.15.20"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.20/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "cb41c48690c113dc08470e64103ce65ca15249c6ce3495d3ac792b329a83e8c1"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.20/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "36b91219b3aae00464e2a4fa361766abd47d0402ac88fbe6da5de44285738386"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.20/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f915de3ab6d31a49f4c57b1f97129f359f9348c162ea03acfa07011ba79e1197"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.20/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "df8e74862d4cd4fdac11faf3048789896ff9898a0cacb98497df20d0a1cc7bb4"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
