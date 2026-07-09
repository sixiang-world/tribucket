class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.15.21"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.21/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "0452f9d5da6e8051d332cf21ae82a608d8e2cfeec5a71a46ffa9e50adbb2381d"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.21/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "7e6ff3bd585b5b7c47634c957ac84fb5806d3c7ab4ef0e5ec1c53ce272f489da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.21/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9846136be7fe5b70351d5bde22fd21d4b3ab55b07c9793fdf190040b296ee9a3"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.15.21/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7ddba1886f39ba918587f9ca37de9651008726834811c19ee83991705bd3e56b"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
