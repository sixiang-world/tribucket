class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.34"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.34/ccx-darwin-arm64"
      sha256 "c365b9373c192ae61379ed84b34e5b1a1ebca7cb49b15bd252599f16ee4d66b7"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.34/ccx-darwin-amd64"
      sha256 "c6401d9a7ee1f5b958f5175c0362b70b0385af7a599c2432263784397c6e9c14"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.34/ccx-linux-arm64"
      sha256 "231f4da9db0b64581f5bb5dec36eba43f23ca98c9146c8f205240d55a34ac9be"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.34/ccx-linux-amd64"
      sha256 "d9bdaef281007454800e1344ec9c5310cd5cf8ca1e6e416ee6bdb15afa337084"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
