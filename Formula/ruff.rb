class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.1/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "a8df4e8e9f22e3b0ae0b9f165ddaafb7e34df692197a6c1a361e7426f90681d5"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.1/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "00396fb9db4cb04e07ad277e6b10d845e6767f0a2aae67e1a57aa65fa01334f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.1/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "52b67c61ca7355a535dfab77f87a4a3ae3550191bead41c70aadded8b5dd33a4"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.1/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7e1cc9b3da4911bb2c98c076302fd8997d822fac74dd8f1e30371701e70a4c56"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
