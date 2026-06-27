class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.20"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.20/ccx-darwin-arm64"
      sha256 "e1e29a1c7ede70e812982dab74402404ada755d9e82643f24da80e3f5d82aadd"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.20/ccx-darwin-amd64"
      sha256 "6b77bedc7471d7afbc50e1bfcfed1dee2ec24a486b3a0033e56f943f53fd6acc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.20/ccx-linux-arm64"
      sha256 "0ebcfd74e0a2d4a4810ae369a31e2f913491bdea43369acfe3dc56435f5985bb"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.20/ccx-linux-amd64"
      sha256 "2f64ee5765f5481ea6135384ef5c4118635446efbd9890cbfaad68f274e9fdd3"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
