class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.6"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.6/uv-aarch64-apple-darwin.tar.gz"
      sha256 "14b459d51ea2e71eeba28c45a268c922bdf8607fc6455e3f40b4e082895d160d"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.6/uv-x86_64-apple-darwin.tar.gz"
      sha256 "2a26ea71bbeff1c7e12c2cc40245c96a041deff276bc921e7038e304d5d3e04c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.6/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d58030acd26159499ac82f32da12d1b3c12a3a1bfc414232d9082070c03e128d"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.6/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8681d8921e7d520fb368991dcf5f9c1905b80f5bf2a265a0ed085c8d8e342477"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
