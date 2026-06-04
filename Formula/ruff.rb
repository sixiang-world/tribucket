class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.15.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.16/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "9deb6c4c38c9324bfd98ea4efb40946aae99a987e7f9d1308a1291f14f6b46e2"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.16/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "a8a7a60182f66b5995bd16e1831cf013e89558edf52135a1b6646f155f491f98"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.16/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a39b83af7288da13c013a789af1a4f875562ba09fc8011a2825a4883cb3a97a9"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.16/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b949a853b208b0f818a150fb06490487db585a15becaeda28483dd662939030a"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
