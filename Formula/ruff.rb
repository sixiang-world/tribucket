class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.4/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "b4ad832b7734592aa1c6710dbc15277ed9d3d54c8bd44bb25bb7b14ae9098b88"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.4/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "233b7368e00b25064abd0db19f7cb1b43117fef41d7106170e6ffec50a0201ca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.4/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "08eb65c07016f1b6d2a874777492a230c7d5822bdf34030af217825b57911b0a"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.4/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9cb1234804ddb0f7f57cef3f81623ce5acb990e40af7cce08dc7778c9d7ee96c"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
