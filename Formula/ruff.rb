class Ruff < Formula
  desc "An extremely fast Python linter and formatter"
  homepage "https://github.com/astral-sh/ruff"
  version "0.17.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.0/ruff-aarch64-apple-darwin.tar.gz"
      sha256 "59afe64c227e5f9a39d85c4d6be6e2d8e9a85c55f0887baad9c9e2f775a1c119"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.0/ruff-x86_64-apple-darwin.tar.gz"
      sha256 "1b6a10f57aa06f0de2d90666878dd875836e3e2d04f61868fa175a74149fb2ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.0/ruff-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "294e181ba6ccb0c2ffd778580e3c42b19f038bdbcb844f39fd9a6a26e8148804"
    end
    on_intel do
      url "https://github.com/astral-sh/ruff/releases/download/0.17.0/ruff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c94fc1dc71f054d06d9f1149442dcb471516aa2b7d4b7e8124e05d082d4c91d3"
    end
  end

  def install
    bin.install Dir["ruff*"].first => "ruff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruff --version 2>&1", 1)
  end
end
