class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.18"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.18/uv-aarch64-apple-darwin.tar.gz"
      sha256 "cf40e0c6a202190ccd9e0406dcfdd5b2d6668a9a5c779b17948963df32aafe5b"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.18/uv-x86_64-apple-darwin.tar.gz"
      sha256 "2e4108f5395397c8bc5d43bf83d3bdbb2d0e92b90d0efa607756be704905fa33"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.18/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "afb6291f3f0a6b4521fc67b947822506c41dde5b60d2189dd8f3695b2ac8c9e7"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.18/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "89eadd7c76fc063887959510d5ba0ab1264dfd5f1143b925ddb73021a40acf16"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
