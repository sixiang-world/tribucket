class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.17.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.4/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "6ef8b3a7fd5294f5e8384ceb29784a6f5657da0853824312b1d2cef53aef17af"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.4/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "0475a156ae8d73ba3386c90207804a72b3d7002ceb9dbca38dabc5d84aa95c9b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.4/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b939676db4532f748dc38c41361a29260f18b3e24a787d46d9278e449c25c2cf"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.4/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3ab2b34aeacdbc1ea5c529cdbda3e05792633d587228123fd09f3b5a0facb27a"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
