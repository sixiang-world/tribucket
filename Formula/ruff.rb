class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.15.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.17/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "81f372886fb7a0056949356c615fa689a091cf79b0b54ed914c810cdbc6d85e9"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.17/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "5522e517bd67ee8c2cb0d6a8298388d8edc8621a0bc5dc773f65e06c953693f6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.17/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "71593a6ca85cfede1743b9163aa4531a273f0eed6ae6c99d26ffe2af51bb5a3d"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.17/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7bca4641db4b0256d20f3a8c38057725e0982965639f5f9a0fb2f9aece4b7c4f"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
