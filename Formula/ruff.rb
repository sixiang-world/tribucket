class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.16.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.6/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "77513748c833b435b82453ba20e07db808ef6c5121945ede80a6cf21bee468a4"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.6/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "87cce7e591603efa979be9044ac00835638a5d9052947070b6e2e7c0cdb21940"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.6/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3c1b99f65b8bf2df64ff099ee072e11b4652813e2c164ec875a26fc9e99be88f"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.16.6/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0696335ef16615d8c7445ad438750eb0f55b3da6f153df21265a7c6d5750254f"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
