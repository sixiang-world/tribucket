class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.26"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.26/ccx-darwin-arm64"
      sha256 "75ee7b56892909cbefa39617173923290f32952abed2c0b87171ec9ec7cbced9"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.26/ccx-darwin-amd64"
      sha256 "87b28b55ad4193f68b872a0f56090338607be6d05374046af3b3452b64380a57"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.26/ccx-linux-arm64"
      sha256 "c3cce26dc78d1f6471c3fde074c98c7a29f442176b8a3047bf2fd23dbeb24efd"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.26/ccx-linux-amd64"
      sha256 "12308eec720e6ee99750ffe692001033bc7796634e49dd2b573d381283964695"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
