class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.27"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.27/ccx-darwin-arm64"
      sha256 "96323929d63893ab2eca637a266b362f908c25b5dd0817372ae698e719458cb5"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.27/ccx-darwin-amd64"
      sha256 "aca1e6a50862087c1fb2b203bc0448e392364e12f9c508199d19bcc9d50e60e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.27/ccx-linux-arm64"
      sha256 "95d9784ae624b32531512e80900a1e4712b953201fa89a4d63fea0b2182a8194"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.27/ccx-linux-amd64"
      sha256 "95946e20b9c4fcf9ddab11bae3773eaf155909801ad3ace1d4da33eb2f3ac6da"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
