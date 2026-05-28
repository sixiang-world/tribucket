class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.8.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v#{version}/ccx-darwin-arm64"
      sha256 ""
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v#{version}/ccx-darwin-amd64"
      sha256 ""
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v#{version}/ccx-linux-arm64"
      sha256 ""
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v#{version}/ccx-linux-amd64"
      sha256 ""
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
