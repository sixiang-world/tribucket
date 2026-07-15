class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.29"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.29/uv-aarch64-apple-darwin.tar.gz"
      sha256 "61c04acc52a33ef0f331e494bdfbedcdb6c26c6970c022ed3699e5860f8930e3"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.29/uv-x86_64-apple-darwin.tar.gz"
      sha256 "c4c4de482da9ccdd076dc4fb5cfe7b740609029385c72f58606be3153602387d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.29/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "94500fb064ae3c971a873cba64d94694c50677e0a4dbf78735c80509e7429919"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.29/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "04f8b82f5d47f0512dcd32c67a4a6f16a0ea27c81537c338fd0ad6b23cebe829"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
