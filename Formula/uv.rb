class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.15"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.15/uv-aarch64-apple-darwin.tar.gz"
      sha256 "dc304b9ed1b24174572290fba60ac3f6fe63c73a671f0439e62a91375841964d"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.15/uv-x86_64-apple-darwin.tar.gz"
      sha256 "e9ca61775532368fe518ab03e7a354c7ecab8ccb3c7d941c775fcc4a362b801b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.15/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0e9a3499b0587d449c9ff684c0160da607826e4af1cee220bc87f378702d3e08"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.15/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f97935763c04be3e692460a7aaeaaab8fc3b78fcf8b389da820b38ae7423a638"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
