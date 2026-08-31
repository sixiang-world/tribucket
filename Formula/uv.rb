class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.8"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.8/uv-aarch64-apple-darwin.tar.gz"
      sha256 "8ce083658dbff20143607ca7af8e0c1d64b6fd7bf03a5cdcb62bf3d47d991b5f"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.8/uv-x86_64-apple-darwin.tar.gz"
      sha256 "bfcd4407de99e0a2c1904df0902fa1795653d4edd145358e6561527e746a4f16"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.8/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ba8661f4fd207c8e94814191598e619b355ac10d5014e851e21eb800f9ef2b00"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.8/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2e2b37e9811e17675a9e70bed5e1a58fc8c0388be63d751d72cc735188c149ff"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
