class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.8.26"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.26/ccx-darwin-arm64"
      sha256 "0e2a1abb7aab13268014e421f7bc2ad0ce38156ca279321714d4f5941fce488d"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.26/ccx-darwin-amd64"
      sha256 "b3b56528a5919c9bf055e4a3d9fb92b3258223c55e87f9cdffa8e1920b45616f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.26/ccx-linux-arm64"
      sha256 "f8695b1f77a7b2239af593c10f10124f55b0687f15f5321026b7357b446fd98b"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.26/ccx-linux-amd64"
      sha256 "9e9ac585440cd030b581c2b64eea7c9610d8ab9155551e27b897fda2f9f6fa17"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
