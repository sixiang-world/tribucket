class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.13.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.13.1/uv-aarch64-apple-darwin.tar.gz"
      sha256 "cfe454573412ff7380d15fc7dae5997ab53ffce72fce0a78e91ddbc84001acd2"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.13.1/uv-x86_64-apple-darwin.tar.gz"
      sha256 "bb7b805bdcf3d0bc8c74ceb94569e6b3e8aa35bd492acdbb9d46bf46d9d4ff6b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.13.1/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9041c73c99fdc5892cf128140beb354eca9231d502068cc36e6cb53a8e59ad14"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.13.1/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eadd9d27c134ab5ac1ffd4473b97a741407f3ea238288f03121fc4deddf90220"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
