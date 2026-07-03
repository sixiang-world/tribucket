class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.32"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.32/ccx-darwin-arm64"
      sha256 "3a834f18a6a655d581deaa8ab397bc6c810b474671595cbe0da6efb9b00296ed"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.32/ccx-darwin-amd64"
      sha256 "e3fa76eda06e51646180c9a40d7f34f6b7b85c53a7c94e2c9ec04b01bb7ed821"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.32/ccx-linux-arm64"
      sha256 "ae27006390c6e207c2455f0192ed0b84ebf6373a78dfc9ddaeb83a7a1fb66cb8"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.32/ccx-linux-amd64"
      sha256 "f1c8e743334531a9f3347a762c215bef6dce28dc004e7bc5d68cc739c707acef"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
