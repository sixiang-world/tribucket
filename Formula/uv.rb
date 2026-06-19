class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.23"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.23/uv-aarch64-apple-darwin.tar.gz"
      sha256 "71ef9de85db820749b3b12b7585624ee279e9c5afcbc6f8236bc3d628c4305b0"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.23/uv-x86_64-apple-darwin.tar.gz"
      sha256 "7a88155033cc469bba5bd5a24212e355eb92e3e2a276320b669ec576296c1e25"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.23/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1873a77350f6621279ae1a0d2227f2bd8b67131598f14a7eb0ba2215d3da2c98"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.23/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e12c4cda2fe8c305510a78380a88f2c32a27e90cdcd123cefd2873388f0ebb5f"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
