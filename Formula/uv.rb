class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.33"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.33/uv-aarch64-apple-darwin.tar.gz"
      sha256 "d75e3d2bfc203d17388edaabd3aa37958edbcbfc36219e3ee0d31bb080b4baa2"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.33/uv-x86_64-apple-darwin.tar.gz"
      sha256 "f1b919f740bd6be1d014ff58c4271b0779a32198adfb19ad9c5d1c4d9b2b4301"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.33/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9ed88a9a42de3102f9704d021ab186fdf8a69a7ad9a1d3f3486ac6b1e55d6141"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.33/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aa9fca823c03289fb6e3460b3dc864f3ea895cafaf9b99247701a67b17d1b018"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
