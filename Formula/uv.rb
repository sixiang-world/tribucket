class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.13.8"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.13.8/uv-aarch64-apple-darwin.tar.gz"
      sha256 "6b71028a6b904f2ae3340ef52e595512de807d06c0a20eaef2f692581b246558"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.13.8/uv-x86_64-apple-darwin.tar.gz"
      sha256 "a04c2ffeac28b2003a2c13caf538ab425fcd7def3e4a41571f4a8fb370a66af3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.13.8/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "74f2f5c6024d397481db228db8fc25eed420db192243f88438c118e7e013e585"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.13.8/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5acfd9177cfecf0bf87578f059728215ccc884388988f55f7a65041b57387d91"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
