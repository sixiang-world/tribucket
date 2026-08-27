class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.7"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.7/uv-aarch64-apple-darwin.tar.gz"
      sha256 "127ebdda7ad953cdf198e964b570ea5771b85467ea93eb7cb6d6f8e6f55408f3"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.7/uv-x86_64-apple-darwin.tar.gz"
      sha256 "06b8ae1da8c2661c5434507a66f8c2b0b835933bf955b5958a9ac357a37d1959"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.7/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "66393193038dd7eb108abd7a218d9cec04ac70ab98242b0720fa94de19223b7c"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.7/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "788f18abea7c5f55d6216e4f5613fd89d4d59b631efeec117b2b07fe72f1da21"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
