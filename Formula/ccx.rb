class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.28"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.28/ccx-darwin-arm64"
      sha256 "b2c2e6af8399f257b99b261ec3536c75305ad73371cd542eee218184854bf105"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.28/ccx-darwin-amd64"
      sha256 "8b239b714bfab13954e7723158be586ce63e45a0eca2260fa690c62565945b89"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.28/ccx-linux-arm64"
      sha256 "e362760628b0685f177c4af4607373f68cb224220f792551b1308cc25758480e"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.28/ccx-linux-amd64"
      sha256 "91c8a02f38668f6ba130962b4bf476eba8cf2284edd9512e345453292e9a0a4f"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
