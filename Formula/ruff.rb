class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.17.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.5/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "4ffadabec5c5fee1ddb2eecac0787ffe6fa18c665b73da9258b84211f40c5829"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.5/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "892f70854ebcd70d873b1bee8358cfd3a1e3180388e3851e3fd3e4a1d5a4dfdd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.5/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4d959d4322a8cd3effe11e9fc6743da1dbb41cd0b2476e433b6e6bfd9a69b626"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.5/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7d261fc981a784668e19e9fa6ad437bfd95b67f2dc263fc1eab87d54d72fcc90"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
