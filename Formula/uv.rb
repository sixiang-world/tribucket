class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.12.9"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.9/uv-aarch64-apple-darwin.tar.gz"
      sha256 "301f72afaf54060f92da7016cb0115bd077f43a9c8e39c1d8170a0bac80fd398"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.9/uv-x86_64-apple-darwin.tar.gz"
      sha256 "e1ca175824f1056589ce9908f7631879ebc3c36535b5e63dc06510beb370b4c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.12.9/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c36fe17937ff6bd16dc42fc13854b5465999fcab2efe0af559381e945e3c6001"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.12.9/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ec7a99cd05e0cd7f80243f135ce1361c76835cb0ee60055d14d20eba8eba1460"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
