class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.1/uv-aarch64-apple-darwin.tar.gz"
      sha256 "77d2906988e8074fd43f2f329ec452ebbf9b0c257ba1c66451c71de70a6baf42"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.1/uv-x86_64-apple-darwin.tar.gz"
      sha256 "69d9f9a00337f25a50dcb13882052da08b8469bac11091c98c5694c3c6721467"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.1/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "769d373e146692c639b5fbaae33b331c297a32e03d30448772051902df52bbf4"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.1/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "90b2f223fb69d19db49e117da601f64978593417988530aa733d456141b4bcbb"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
