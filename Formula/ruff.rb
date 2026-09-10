class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.7/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "80221a5e0b1ae29262a74496f2ad1380c1ab52b3edd8cee13ec76d8acff406ca"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.7/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "6f3b98ec349f470b7efde5294d44e5171613ddaac3c251a918a7946b303d3ec2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.7/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1e06b11127c28387c8066da4ce6a617a84a359591be09dbf581fbb0c3e006239"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.7/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "73894c7b7c9a53fd66ed715eb3a1ec65077f316328e377057a98bdb7fcba0326"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
