class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.14/ccx-darwin-arm64"
      sha256 "09d15042c49bbfff542d7253b3f982f1156e3ed438b80b0462f1b9eaec7a488a"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.14/ccx-darwin-amd64"
      sha256 "4166ada5f8fe777e8d9282a97461fb3184ac180cf60f0fbc942fd2b5961955e4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.14/ccx-linux-arm64"
      sha256 "d1c2988c6ef42a4a3dcabdb24114d12fda021ce7e6359c30ab21c5fd89f59afa"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.14/ccx-linux-amd64"
      sha256 "2b73f40cbc59a81bc0cb22af0e61cbb89aa0354a3e19d1dadc43905df28231a4"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
