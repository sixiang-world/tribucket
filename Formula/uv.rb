class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.0/uv-aarch64-apple-darwin.tar.gz"
      sha256 "2b9e582af54f84fa50c115427451a6c13e80f43b52f8282b8af5791077317bbf"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.0/uv-x86_64-apple-darwin.tar.gz"
      sha256 "d41593beaefc54bab7d062af0ef6ca093bfb81d001d58ebbef39e44423f9c496"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.0/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2c5d6e3092cc5223b10ff403880cc75121bf64e84644e7a0c69f643b0d89ac95"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.0/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eaf842262aa1c418d8ecc5605f02ee1ebfd369124fa48548e85f9481a47831a9"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
