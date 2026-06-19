class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.11.22"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.22/uv-aarch64-apple-darwin.tar.gz"
      sha256 "97a45e2ff8d5ea262623eed57ec2d9c468a42d74496d5c3c3eef11340235bd7f"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.22/uv-x86_64-apple-darwin.tar.gz"
      sha256 "9490033dc405b4afc8fa5f9ecd5cc1793e80c727a8c42c32ad456778720d39f2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.11.22/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "54b22e9f5570f3643cdf85a33bbc8e9feb3fc6e836a7c660c05378434ef44fe2"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.11.22/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "30075b14624a62021198319f22e08f1651a97d4026a8c84dab6abcbfaba0d81c"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
